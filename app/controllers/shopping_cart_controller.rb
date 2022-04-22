class ShoppingCartController < ApplicationController

  def index
    user = Current.user
    cart = user.shopping_cart
    @cart_items = cart.cart_products.all
  end

end
