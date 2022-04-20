class ProductsController < ApplicationController
  before_action :admin_authorization, only: %i(new create edit destroy update)
  before_action :load_product, only: %i(show edit destroy update)

  def new
    @product = Product.new
  end

  def show
    @is_admin = is_admin?
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to root_path, status: :see_other
    flash[:notice] = "Product Deleted Succesfully."
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

  def load_product
    @product = Product.find_by(id: params[:id])
    unless @product.present?
      redirect_to root_path
      flash[:notice] = "Something went Wrong :- Product does not exist."
    end
  end

end
