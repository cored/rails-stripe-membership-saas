class UpdateCustomerWorker
  include Sidekiq::Worker

  attr_accessor :user, :customer

  def perform(user_id, stripe_token)
    @user = User.find(user_id)

    @customer = Stripe::Customer.retrieve(user.customer_id)
    update_customer(stripe_token)
    update_user
  
  end

  def update_customer(stripe_token)
    if stripe_token.present?
      @customer.card = stripe_token
    end
    @customer.email = user.email
    @customer.description = user.name
    @customer.save!
  end

  def update_user 
    @user.update_with_stripe_data(@customer)
  end
end
