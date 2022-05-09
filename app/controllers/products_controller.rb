class ProductsController < ApplicationController
  before_action :admin_authorization, only: %i(new create edit destroy update)
  before_action :load_product, only: %i(show edit destroy update)

  def new
    @product = Product.new
  end

  def show; end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_handler(@product, "Product added succesfully.")
    else
      render :new
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_handler(@product, "Product Updated succesfully.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_handler(root_path, "Product Deleted Succesfully.")
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :description, :category, photos: [])
  end

  def admin_authorization
    if current_user&.email != "admin@gmail.com"
      redirect_handler(root_path, "You can not perform certain actions")
    end
  end

  def load_product
    @product = Product.find_by(id: params[:id])
    unless @product.present?
      redirect_handler(root_path, "Something went Wrong :- Product does not exist.")
    end
  end

end
