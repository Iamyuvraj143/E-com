class AddressesController < ApplicationController
  before_action :auth_check
  before_action :load_user, only: %i( edit destroy update)

  def new
    @user = Current.user
    @address = @user.addresses.new
  end

  def create
    @address = Current.user.addresses.new(address_params)
    if @address.save
      redirect_to user_path(Current.user)
      flash[:notice] = "Address added Succesfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to user_path(@user)
      flash[:notice] = "Address updated succesfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @address.destroy 
    redirect_to user_path(@user), status: 303
    flash[:notice] = "Address Deleted Succesfully."
  end

  private

  def address_params
    params.require(:address).permit(:address_line, :city, :state, :zipcode, :country)
  end

  def load_user
      @user = Current.user
      @address = @user.addresses.find_by(id: params[:id])
      if !@address.present?
        redirect_to user_path(@user)
        flash[:notice] = "Something wnet Wrong :- Address does not exist."
      end
  end

  def auth_check
    # allows only logged in user
    @user = User.find_by(id: params[:user_id])
    if @user.nil? || Current.user.id != @user.id
      redirect_to root_path
      flash[:notice] = "Invalid opertion performed."
    end
  end

end
