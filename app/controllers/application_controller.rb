class ApplicationController < ActionController::Base
  before_action :set_current_user

  private
  
  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def auth_check
    # allows only logged in user
    @user = User.find_by(id: session[:user_id])
    if session[:user_id] != @user.id
      redirect_to user_path(Current.user)
      flash[:notice] = "Invalid opertion performed."
    end
  end

end
