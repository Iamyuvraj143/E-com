class ShoppingCartController < ApplicationController
  before_action :auth_check
  
  def index
    user = Current.user
    cart = user.shopping_cart
    @cart_products = cart.cart_products.all
  end

end
