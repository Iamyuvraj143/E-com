class WelcomeController < ApplicationController
   before_action :load_cart, only: %i( index )
  
  def index
    @products = Product.all
  end

end
