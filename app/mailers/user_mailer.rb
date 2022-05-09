class UserMailer < ApplicationMailer
  default from: 'jarvuy7@gmail.com'

  def welcome_email
    @user = params[:user]
    @url  = 'http://ecom.com/login'
    mail(to: @user.email, subject: 'Welcome to My E-com Site')
  end
end
