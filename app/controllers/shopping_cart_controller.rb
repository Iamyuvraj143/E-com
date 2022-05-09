class ShoppingCartController < ApplicationController
  before_action :authenticate_user!
  
  def index
    cart = current_user.shopping_cart
    @cart_products = cart.cart_products.all
  end

end
