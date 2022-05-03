class CartProductsController < ApplicationController
  before_action :auth_check
  before_action :load_cart, only: %i( new create edit update destroy)

  def new
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
      redirect_to shopping_cart_index_path
      flash[:notice] = "Something went Wrong :- Cart item does not exist."
    else
      @cart_product.destroy 
      redirect_to shopping_cart_index_path status: 303
      flash[:notice] = "Cart item Removed."
    end
  end

  private

  def cart_params
    params.require(:cart_product).permit(:product_id, :quantity, :total)
  end

end
