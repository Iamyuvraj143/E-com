class SendWelcomeEmailToNewUserJob < ApplicationJob
  queue_as :default

  def perform(user)
    UserMailer.with(user: user).welcome_email.deliver_later
  end
end
