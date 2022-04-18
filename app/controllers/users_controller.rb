class UsersController < ApplicationController
  before_action :auth_check
  
  def show
    @user = Current.user
    @addresses = @user.addresses.compact
  end

end
