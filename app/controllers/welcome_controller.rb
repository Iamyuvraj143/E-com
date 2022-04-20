class WelcomeController < ApplicationController
  def index
    @is_admin = is_admin?
    @products = Product.all
  end

end
