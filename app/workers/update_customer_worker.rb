class UpdateCustomerWorker
  include Sidekiq::Worker

  def perform(user_id, stripe_token)
      user = User.find(user_id)

      customer = Stripe::Customer.retrieve(user.customer_id)
      if stripe_token.present?
        customer.card = stripe_token
      end
      customer.email = user.email
      customer.description = user.name
      customer.save!

      user.update_with_stripe_data(customer)
  end
end
