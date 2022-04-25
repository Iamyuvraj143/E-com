class ShoppingCartController < ApplicationController
  before_action :auth_check
  
  def index
    user = Current.user
    cart = user.shopping_cart
    @cart_items = cart.cart_products.all
  end

  private

  def auth_check
    
    unless Current.user
      redirect_to sign_in_path
      flash[:notice] = "You must login First"
    end
  end

end
