class ShoppingCartController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @cart = current_user.shopping_cart
    @addresses = current_user.addresses
    @cart_products = @cart.cart_products
  end

end
