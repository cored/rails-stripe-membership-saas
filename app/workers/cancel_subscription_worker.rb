class CancelSubscriptionWorker
  include Sidekiq::Worker

  def perform(customer_id)
    customer = Stripe::Customer.retrieve(customer_id)
    unless customer.nil? or customer.respond_to?('deleted')
      if customer.subscription.status == 'active'
        customer.cancel_subscription
      end
    end
  end
end
