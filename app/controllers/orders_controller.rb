class OrdersController < ApplicationController
  before_action :auth_check
  before_action :create_order_essentials, only: %i(create)
  before_action :load_order_for_edit_update, only: %i(edit update)
  before_action :new_order_load, only: %i(new)

  def index
    @orders = Current.user.orders.eager_load(:order_items)
  end

  def new
    check_product_stock
    @user = Current.user
    @addresses = @user.addresses.all
    @order = @user.orders.new
  end

  def show
    @order = Current.user.orders.find_by(id: params[:id])
    unless @order.present?
      redirect_to root_path
      flash[:notice] = "Something went Wrong :- Order does not exist."
    end
    @order_item = @order.order_items
  end

  def create
    @order = Current.user.orders.new(order_params)
    if @order.save
      if @cart_product.present?
        @cart_product.destroy
      end
      @order_item = @order.order_items.new(order_item_params)
      @order_item.price = @total
      @order_item.save
      redirect_to @order
      flash[:notice] = "congratulation !! Your Order Placed Successfully. "
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @order.update(order_params)
      redirect_to @order
      flash[:notice] = "Order cancelled succesfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:address, :status)
  end

  def order_item_params
    params.require(:order).permit(:product_id, :quantity)
  end

  def check_product_stock
   if @product.quantity <= 0
    redirect_to root_path
    flash[:notice] = "Currently the product is out of stock"
   end
  end

  def create_order_essentials
    data_for_order_item =  params.require(:order).permit(:quantity, :product_id, :cart_id).to_h
    @product_id = data_for_order_item['product_id']
    @quantity = data_for_order_item['quantity']
    @product = Product.find_by(id: @product_id)
    unless @product.present?
      redirect_to root_path
      flash[:notice] = "Something went Wrong :- Product does not exist."
    end
    @cart_product = CartProduct.find_by(id:data_for_order_item['cart_id'])
    @total = @product.price * @quantity.to_f
 end

  def load_order_for_edit_update
    @order = Current.user.orders.find_by(id: params[:id])
    unless @order.present?
      redirect_to root_path
      flash[:notice] = "Something went Wrong :- Order does not exist."
    end
  end

  def new_order_load
    @quantity =  params[:quantity]
    @cart_id =   params[:cart_id]
    @product = Product.find_by(id: params[:product_id])
    unless @product.present?
      redirect_to root_path
      flash[:notice] = "Something went Wrong :- Product does not exist."
    end
  end

end
