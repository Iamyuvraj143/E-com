class UsersController < ApplicationController
 before_action :authenticate_user!
  
  def show
    @addresses = current_user.addresses.compact
  end

end
