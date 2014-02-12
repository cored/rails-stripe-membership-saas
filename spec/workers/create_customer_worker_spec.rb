require 'spec_helper'

describe CreateCustomerWorker do 

  it 'uses a User record to create a customer on Stripes end' do 
    user = double(:user, email: "test@testing.com", 
                  stripe_token: "12345",name:"Test User", 
                  password:"password",
                  roles:[double(:role, name:"Silver Subscription")])
    User.should_receive(:find).and_return(user)
    Stripe::Customer.should_receive(
      :create
    ).and_return(
      double(:customer,id:12345,
             cards:double(:cards, data:[{"last4" => "4242"}]))
    )
    user.should_receive(:last_4_digits=)
    user.should_receive(:customer_id=)
    user.should_receive(:stripe_token=)
    user.should_receive(:save!)
    CreateCustomerWorker.new.perform(12345, "12345", "DISCOUNT_COUPON")
  end

  it 'saves the data it gets back from Stripe onto a User record'

end
