class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @address = @user.addresses
  end

end
