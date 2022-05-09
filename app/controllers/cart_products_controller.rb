class CartProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart, only: %i( new create edit update destroy)
  before_action :check_product_stock, only: %i(new)

  def new
    @cart_product = @cart.cart_products.new
  end

  def create
    @cart_product = @cart.cart_products.new(cart_params)
    @cart_product.total = @cart_product.product.price * @cart_product.quantity
    if @cart_product.save
      redirect_handler(shopping_cart_index_path, "Product added to cart")
    else
      render :new 
    end
  end

  def destroy
    @cart_product = @cart.cart_products.find_by(id: params[:id])
    unless @cart_product.present?
      redirect_handler(shopping_cart_index_path, "Something went Wrong :- Cart item does not exist.")
    else
      @cart_product.destroy
      redirect_handler(shopping_cart_index_path, "Cart item Removed.")
    end
  end

  private

  def cart_params
    params.require(:cart_product).permit(:product_id, :quantity, :total)
  end

  def load_cart
    @cart = current_user.shopping_cart
    @product_id = params[:product_id]
    @product = Product.find_by(id:[@product_id])
  end

end
