require 'spec_helper'

describe CreateCustomerWorker do 

  before do 
    @user = double(:user, email: "test@testing.com", 
                  stripe_token: "12345",name:"Test User", 
                  password:"password",
                  roles:[double(:role, name:"Silver Subscription")])
    @customer = double(:customer,id:12345,
             cards:double(:cards, data:[{"last4" => "4242"}]))
    @create_customer_worker = CreateCustomerWorker.new
  end

  it 'uses a User record to create a customer on Stripes end' do 
    @create_customer_worker.user = @user
    Stripe::Customer.should_receive(:create).and_return(@customer)
    @create_customer_worker.create_customer("12345", "DISCOUNT_COUPON")
  end

  it 'saves the data it gets back from Stripe onto a User record' do 
    @create_customer_worker.user = @user
    @create_customer_worker.customer = @customer
    @user.should_receive(:update_with_stripe_data).with(@customer)
    @create_customer_worker.update_user
  end

end
