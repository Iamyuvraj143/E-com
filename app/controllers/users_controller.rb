class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @addresses = @user.addresses.compact
    @address = @user.addresses.new
  end

end
