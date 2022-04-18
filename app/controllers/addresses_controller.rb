class AddressesController < ApplicationController
  before_action :auth_check

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
    begin
      @user = User.find_by(id: session[:user_id])
      @address = @user.addresses.find_by(id: params[:id])
    rescue StandardError => e
      redirect_to root_path, status: 303
      flash[:notice] = "Something went Wrong.#{e}"
    end
  end

   def update
    begin
      user = User.find_by(id: session[:user_id]) 
      @address = user.addresses.find_by(id: params[:id])
      if @address!=nil
        if @address.update(address_params)
          redirect_to user_path(user)
        else
          render :edit, status: :unprocessable_entity
        end
      end
    rescue StandardError => e
      redirect_to root_path, status: 303
      flash[:notice] = "Something went Wrong.#{e}"
    end
  end


  def destroy
    begin
      user = User.find_by(id: session[:user_id]) 
      @address = user.addresses.find_by(id: params[:id])
      if @address!=nil
        @address.destroy 
        redirect_to user_path(user), status: 303
        flash[:notice] = "Address Deleted Succesfully."
      else
        redirect_to user_path(user), status: 303
        flash[:notice] = "Address not Deleted :- address not found."
      end
    rescue StandardError => e
      redirect_to root_path, status: 303
      flash[:notice] = "Something went Wrong.#{e}"
    end
  end

  private

  def address_params
    params.require(:address).permit(:address_line, :city, :state, :zipcode, :country)
  end

end
