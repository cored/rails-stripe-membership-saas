class ExpirationEmailWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find user_id
    UserMailer.expire_email(user).deliver
  end


end
