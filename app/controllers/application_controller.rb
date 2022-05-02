class ApplicationController < ActionController::Base
  before_action :set_current_user

  private
  
  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def auth_check
    unless Current.user
      redirect_handler(sign_in_path, "You must login First")
    end
  end

  def check_product_stock
    if @product.quantity <= 0
      redirect_handler(root_path, "Currently the product is out of stock")
    end
  end

  def redirect_handler(redirect_path, message)
    redirect_to redirect_path
    flash[:notice] = message
  end

end
