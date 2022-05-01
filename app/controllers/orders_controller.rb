class OrdersController < ApplicationController
  before_action :auth_check
  after_action :update_stock, only: %i(create)
  before_action :load_user_and_addresses,  only: %i(new)
  before_action :create_order_essentials, only: %i(create)
  before_action :load_order, only: %i(edit update)
  before_action :new_order_load, only: %i(new)

  def index
    @orders = Current.user.orders.eager_load(:order_items)
  end

  def new
    check_product_stock
    @order = @user.orders.new
  end

  def show
    load_order
    @order_item = @order.order_items
  end

  def create
    @order = Current.user.orders.new(order_params)
    if @order.save
      order_product
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

  def load_order
    @order = Current.user.orders.find_by(id: params[:id])
    unless @order.present?
      redirect_to root_path
      flash[:notice] = "Something went Wrong :- Order does not exist."
    end
  end

  def new_order_load
    @quantity =  params[:quantity]
    @product = Product.find_by(id: params[:product_id])
    unless @product.present?
      redirect_to root_path
      flash[:notice] = "Something went Wrong :- Product does not exist."
    end
  end

  def order_product
    if @cart_product.present?
      @cart_product.destroy
    end
    @order_item = @order.order_items.new(order_item_params)
    @order_item.price = @total
    @order_item.save
    redirect_to @order
    flash[:notice] = "congratulation !! Your Order Placed Successfully. "
  end

  def load_user_and_addresses
    @user = Current.user
    @addresses = @user.addresses
    unless @addresses.present?
      redirect_to @user
      flash[:notice] = "Please add a address first"
    end
  end

  def update_stock
    @product.quantity -= @quantity.to_i
    @product.save
  end

end
