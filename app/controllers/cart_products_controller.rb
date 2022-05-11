class CartProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart, only: %i( new create edit update destroy)
  before_action :load_cart_for_update, only: %i(update)

  def new
    @product = Product.find(@product_id)
    check_product_stock
    @cart_product = @cart.cart_products.new
  end

  def create
    @cart_product = @cart.cart_products.new(cart_params)
    @cart_product.total = @cart_product.product.price * @cart_product.quantity
    respond_to do |format|
      if @cart_product.save
        format.html { redirect_to shopping_cart_index_path, notice: 'Added to cart' }
        format.js
        format.json { render json: @cart_product, status: :created, location: root_path }
      else
        format.html { render action: "new" }
        format.json { render json: @cart_product.errors, status: :unprocessable_entity }
      end
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

  def update; end

  private

  def cart_params
    params.require(:cart_product).permit(:product_id, :quantity, :total)
  end

  def load_cart_for_update
    quantity = params[:qty].to_i
    cart_product = @cart.cart_products.find_by(id: params[:id])
    if cart_product.present? && cart_product.product.quantity>=quantity
      cart_product.update(quantity:quantity)
    else
       redirect_handler(shopping_cart_index_path, "Only #{cart_product.product.quantity} products in stock")
    end
  end

end
