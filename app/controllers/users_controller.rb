class UsersController < ApplicationController
  before_action :auth_check
  
  def show
    @user = User.find_by(id: Current.user[:id]) 
    @addresses = @user.addresses.compact
  end

end
