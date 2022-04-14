class AddressesController < ApplicationController
  def create
    @user = Current.user
    @address = @user.addresses.create(address_params)
    redirect_to user_path(@user)
    flash[:notice] = "Address added Succesfully."
  end

  def destroy
    @user = User.find(params[:user_id])
    @address = @user.addresses.find(params[:id])
    @address.destroy
    redirect_to user_path(@user), status: 303
    flash[:notice] = "Address Deleted Succesfully."
  end

  private

  def address_params
    params.require(:address).permit(:address_line, :city, :state, :country, :zipcode)
  end

end
