class ShoppingCartController < ApplicationController
  before_action :auth_check
  
  def index
    @cart = Current.user.shopping_cart
    @addresses = Current.user.addresses
    @cart_products = @cart.cart_products
  end

end
