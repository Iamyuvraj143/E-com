class ApplicationController < ActionController::Base
  before_action :set_current_user

  private
  
  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def auth_check
    # allows only logged in user
   @user = User.find_by(id: params[:id])  
    if @user.nil? || Current.user.id != @user.id  
      redirect_to root_path
      flash[:notice] = "Invalid opertion performed. "
    end
  end

end
