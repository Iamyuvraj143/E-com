class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user_addresses, only: %i[new]
  before_action :load_cart_and_products, only: %i[new]
  before_action :new_order_load, only: %i[new]
  before_action :load_data_for_batch_order, only: %i[create]
  before_action :create_single_order_essentials, only: %i[create]
  before_action :load_order, only: %i[edit update show]

  def index
    @orders = current_user.orders.eager_load(:order_items)
  end

  def new
    @order = current_user.orders.new
  end

  def show
    @order_item = @order.order_items
  end

  def create
    if @batch_order
      place_batch_order
    else
      @order = current_user.orders.create(order_params)
      order_product
    end
    redirect_handler(orders_path, 'congratulation !! Your Order Placed Successfully.')
  end

  def edit; end

  def update
    if @order.update(order_params)
      redirect_handler(@order, 'Order Cancelled Successfully')
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

  def create_single_order_essentials
    return if @batch_order

    data_for_order_item = params.require(:order).permit(:quantity, :product_id).to_h
    @quantity = data_for_order_item['quantity']
    @product = Product.find_by(id: data_for_order_item['product_id'])
    null_value_check(@product, root_path, 'Something went Wrong :- Product does not exist.')
    @total = @product.price * @quantity.to_f
  end

  def load_order
    @order = current_user.orders.find_by(id: params[:id])
    null_value_check(@order, root_path, 'Something went Wrong :- Order does not exist.')
  end

  def new_order_load
    @batch_order = params[:batch_order?]
    if @batch_order
      @grand_total = 0
    else
      @quantity =  params[:quantity]
      @product = Product.find_by(id: params[:product_id])
      null_value_check(@product, root_path, 'Something went Wrong :- Product does not exist.')
      check_product_stock
    end
  end

  def order_product
    @order_item = @order.order_items.new(order_item_params)
    @order_item.price = @total
    @order_item.save
    update_stock(@product, @quantity)
  end

  def load_user_addresses
    @addresses = current_user.addresses
    null_value_check(@addresses, current_user, 'Please add a address')
  end

  def update_stock(product, quantity)
    product.quantity -= quantity.to_i
    product.save
  end

  def load_cart_and_products
    @cart = current_user.shopping_cart
    @order_list = @cart.cart_products.joins(:product).with_in_stock
  end

  def place_batch_order
    @order_list.each do |item|
      @order = current_user.orders.create(order_params)
      @order_item = @order.order_items.create(product_id: item.product_id, quantity: item.quantity, price: item.total)
      update_stock(item.product, item.quantity)
      @cart_products.delete(item)
    end
  end

  def load_data_for_batch_order
    @batch_order = params.require(:order).permit(:batch_order).to_h['batch_order']
    @cart = current_user.shopping_cart
    @cart_products = @cart.cart_products.all
    @order_list = @cart.cart_products.joins(:product).with_in_stock
  end
end
