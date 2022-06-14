class ApplicationController < ActionController::Base
  before_action :configure_sign_up_params_permitted_parameters, if: :devise_controller?
  before_action :configure_account_update_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def check_product_stock
    return if @product.quantity >= 0

    redirect_handler(root_path, 'Currently the product is out of stock')
  end

  def load_cart
    return unless current_user

    user = current_user
    @cart = user.shopping_cart
    @product_id = params[:product_id]
    @cart_product = @cart.cart_products.new
  end

  def redirect_handler(redirect_path, message)
    redirect_to redirect_path
    flash[:notice] = message
  end

  def record_not_found
    redirect_handler(root_path, 'Error 404: Record not found')
  end

  protected

  def configure_sign_up_params_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:  %i[name avatar])
  end

  def configure_account_update_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
  end
end
