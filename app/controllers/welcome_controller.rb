class WelcomeController < ApplicationController
  def index
    @is_admin = is_admin?
    @products = Product.all
  end

  private

  def is_admin?
    Current.user&.email == "admin@gmail.com" ? true : false
  end

end
