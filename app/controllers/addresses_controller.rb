class AddressesController < ApplicationController
  
  before_action :set_current_user
  
  def create
    @address = Current.user.addresses.create(address_params)
    if @address.save
      redirect_to user_path(Current.user)
      flash[:notice] = "Address added Succesfully."
    else
      redirect_to user_path(Current.user)
      flash[:notice] = "Address can not be saved All Field are required."
    end
  end

  def destroy
    begin
      user = User.find(params[:user_id])
      @address = user.addresses.find(params[:id])
      if @address.destroy
        redirect_to user_path(user), status: 303
        flash[:notice] = "Address Deleted Succesfully."
      else
        redirect_to user_path(user), status: 303
        flash[:notice] = "Address not Deleted."
      end
    rescue StandardError => e
      redirect_to root_path, status: 303
      flash[:notice] = "Something went Wrong.#{e}"
    end
  end

  private

  def address_params
    params.require(:address).permit(:address_line, :city, :state, :country, :zipcode)
  end

end
