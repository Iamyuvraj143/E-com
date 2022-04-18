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
    begin
    rescue StandardError => e
      redirect_to root_path, status: 303
      flash[:notice] = "Something went Wrong => .#{e}"
    end
  end

   def update
    begin
      if @address.present?
        if @address.update(address_params)
          redirect_to user_path(@user)
           flash[:notice] = "Address updated succesfully."
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
      if @address.present?
        @address.destroy 
        redirect_to user_path(@user), status: 303
        flash[:notice] = "Address Deleted Succesfully."
      else
        redirect_to user_path(@user), status: 303
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

  def load_user
    @user = User.find_by(id: session[:user_id]) 
    @address = @user.addresses.find_by(id: params[:id])
  end

end
