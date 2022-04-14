class WelcomeController < ApplicationController
  def index
    @user = Current.user
    @products = Product.all
  end
end
