class UsersController < ApplicationController
 before_action :auth_check
  
  def show
    @user = Current.user
    @addresses = @user.addresses.compact
  end

  private

  def auth_check
    # allows only logged in user
    @user = User.find_by(id: params[:id])  
    if Current.user.id != @user&.id  
      redirect_to root_path
      flash[:notice] = "Invalid opertion performed. "
    end
  end

end
