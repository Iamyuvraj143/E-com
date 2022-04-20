class WelcomeController < ApplicationController
  def index
    @user = Current.user
    @is_admin = is_admin?
    @products = Product.all
  end

  private

  def is_admin?
    Current.user&.email == "admin@gmail.com" ? true : false
  end

end
