class ProductsController < ApplicationController

  before_action :admin_authorization, only: %i(new create edit destroy update)

	def new
		@user = Current.user
		@product = Product.new
	end

	def show
    @is_admin = is_admin?
		@user = Current.user
		@product = Product.find(params[:id])
	end

	def create
    @user = Current.user
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product
    else
      render :new
    end
  end

  def edit
    @user = Current.user
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = Current.user
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to root_path, status: :see_other
  end

  private

    def product_params
      params.require(:product).permit(:name, :price, :quantity, :description, :category, :image)
    end

    def admin_authorization
      if Current.user&.email != "admin@gmail.com"
        redirect_to root_path
        flash[:notice] = "You can not perform certain actions"
      end
    end

    def is_admin?
     Current.user&.email == "admin@gmail.com" ? true : false
    end

end
