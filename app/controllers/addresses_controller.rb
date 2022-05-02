class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: %i( edit destroy update)

  def new
    @address = current_user.addresses.new
  end

  def create
    @address = current_user.addresses.new(address_params)
    if @address.save
      redirect_to user_path(current_user)
      flash[:notice] = "Address added Succesfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @address.update(address_params)
      redirect_to user_path(current_user)
      flash[:notice] = "Address updated succesfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @address.destroy 
    redirect_to user_path(current_user), status: 303
    flash[:notice] = "Address Deleted Succesfully."
  end

  private

  def address_params
    params.require(:address).permit(:address_line, :city, :state, :zipcode, :country)
  end

  def load_user
    @address = current_user.addresses.find_by(id: params[:id])
    unless @address.present?
      redirect_to user_path(current_user)
      flash[:notice] = "Something went Wrong :- Address does not exist."
    end
  end

end
