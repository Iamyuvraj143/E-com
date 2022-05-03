class ApplicationController < ActionController::Base
  before_action :set_current_user

  private
  
  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def auth_check
    
    unless Current.user
      redirect_to sign_in_path
      flash[:notice] = "You must login First"
    end
  end

  def load_cart
    if Current.user
      user = Current.user
      @cart = user.shopping_cart
      @product_id = params[:product_id]
      @cart_product = @cart.cart_products.new
    end
  end

end
