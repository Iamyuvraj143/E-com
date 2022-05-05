class ApplicationController < ActionController::Base
  before_action :set_current_user
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :configure_permitted_parameters1, if: :devise_controller?


  private
  
  def set_current_user
    current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

   protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
  end

  def configure_permitted_parameters1
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end

end
