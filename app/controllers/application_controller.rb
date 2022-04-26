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

end
