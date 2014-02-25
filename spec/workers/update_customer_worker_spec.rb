require 'spec_helper' 

describe UpdateCustomerWorker do 

  before do 
    @user = double(:user, email: 'test@testing.com',
                          name: 'Test User')
    @customer = double(:customer, id:12345, cards:double(:cards, data: [ 
      {"last4" => "4242"}]))
    @update_customer_worker = UpdateCustomerWorker.new
    @update_customer_worker.user = @user 
    @update_customer_worker.customer = @customer
  end

  it "uses a User record to update a customer on Stripe's end" do 
    @customer.should_receive(:save!)
    @customer.should_receive(:card=).with("12345")
    @customer.should_receive(:email=).with(@user.email)
    @customer.should_receive(:description=).with(@user.name)
    @update_customer_worker.update_customer("12345")
  end

  it "saves the data it gets back from Stripe onto a User record" do 
    @user.should_receive(:update_with_stripe_data).with(@customer)
    @update_customer_worker.update_user
  end

end
