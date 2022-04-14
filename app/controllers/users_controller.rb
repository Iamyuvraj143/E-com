class UsersController < ApplicationController

  def show
    @user = Current.user
    @user = User.find(params[:id])
  end

end
