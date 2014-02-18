class CreateCustomerWorker 
  include Sidekiq::Worker

  attr_accessor :user, :customer
  def perform(user_id, stripe_token, coupon)
    @user = User.find(user_id)
    create_customer(stripe_token, coupon)
    update_user
  end

  def create_customer(stripe_token, coupon)
    create_attrs = {email: @user.email,
                    description: @user.name, 
                    card: stripe_token, 
                    plan: @user.roles.first.name}
    unless coupon.blank?
      create_attrs.merge! coupon:coupon
    end
    @customer = Stripe::Customer.create(create_attrs)
  end

  def update_user
    @user.last_4_digits = @customer.cards.data.first["last4"]
    @user.customer_id = @customer.id
    @user.stripe_token = nil
    @user.save!
  end
end
