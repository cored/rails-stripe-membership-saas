class UpdateSubscriptionWorker 
  include Sidekiq::Worker

  def perform(options)
    custommer Stripe::Customer.retrieve(options.fetch(:customer_id))
    customer.update_subscription(plan:options.fetch(:role_name))
  end
end
