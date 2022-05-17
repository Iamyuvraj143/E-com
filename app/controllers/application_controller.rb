class ApplicationController < ActionController::Base
  before_action :set_current_user
  before_action :configure_sign_up_params_permitted_parameters, if: :devise_controller?
  before_action :configure_account_update_permitted_parameters, if: :devise_controller?


  private
  
  def set_current_user
    current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  protected

  def configure_sign_up_params_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
  end

  def configure_account_update_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end

  def check_product_stock
    if @product.quantity <= 0
      redirect_handler(root_path, "Currently the product is out of stock")
    end
  end

  def load_cart
    if current_user
      user = current_user
      @cart = user.shopping_cart
      @product_id = params[:product_id]
      @cart_product = @cart.cart_products.new
    end
  end

  def redirect_handler(redirect_path, message)
    redirect_to redirect_path
    flash[:notice] = message
  end

end
