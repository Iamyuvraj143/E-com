class CartProductsController < ApplicationController
  before_action :auth_check
  before_action :load_cart, only: %i( new create edit update destroy)

  def new
    @cart_product = @cart.cart_products.new
  end

  def create
    @cart_product = @cart.cart_products.new(cart_params)
    @cart_product.total = @cart_product.product.price * @cart_product.quantity
    if @cart_product.save
      redirect_to shopping_cart_index_path status: 303
      flash[:notice] = "added to cart"
    else
      render :new 
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

  def load_cart
    user = Current.user
    @cart = user.shopping_cart
    @product_id = params[:product_id]
  end

end
