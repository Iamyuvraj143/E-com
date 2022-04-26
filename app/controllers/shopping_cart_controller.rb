class ShoppingCartController < ApplicationController
  before_action :auth_check
  
  def index
    cart = Current.user.shopping_cart
    @cart_products = cart.cart_products.all
  end

end
