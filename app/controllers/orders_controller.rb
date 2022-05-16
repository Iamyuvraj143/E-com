class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user_addresses,  only: %i(new)
  before_action :new_order_load, only: %i(new)
  after_action :update_stock, only: %i(create)
  before_action :get_data_for_batch_order, only: %i(create)
  before_action :create_single_order_essentials, only: %i(create)
  before_action :single_order, only: %i(create)
  before_action :load_order, only: %i(edit update show)

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
      redirect_handler(orders_path, "Your order placed ")
    end
  end

  def edit; end

  def update
    if @order.update(order_params)
      redirect_handler(@order, "Order Cancelled Successfully")
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

  def single_order
    unless @batch_order
      @order = current_user.orders.new(order_params)
      if @order.save
        order_product
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def create_single_order_essentials
    unless @batch_order 
      data_for_order_item =  params.require(:order).permit(:quantity, :product_id, :cart_id).to_h
      product_id = data_for_order_item['product_id']
      quantity = data_for_order_item['quantity']
      @product = Product.find_by(id: product_id)
      unless @product.present?
        redirect_handler(root_path, "Something went Wrong :- Product does not exist.")
      end
      @cart_product = CartProduct.find_by(id:data_for_order_item['cart_id'])
      @total = @product.price * quantity.to_f
    end
  end

  def load_order
    @order = current_user.orders.find_by(id: params[:id])
    unless @order.present?
      redirect_handler(root_path, "Something went Wrong :- Order does not exist.")
    end
  end

  def new_order_load
    @batch_order = params[:batch_order?]
    if @batch_order
      @cart = ShoppingCart.find_by(id:params[:cart_id])
      @grand_total = 0
      load_cart_and_products
    else
      quantity =  params[:quantity]
      @product = Product.find_by(id: params[:product_id])
      check_product_stock
      unless @product.present?
        redirect_handler(root_path, "Something went Wrong :- Product does not exist.")
      end
    end
  end

  def order_product
    if @cart_product.present?
      @cart_product.destroy
    end
    @order_item = @order.order_items.new(order_item_params)
    @order_item.price = @total
    @order_item.save
    redirect_handler(@order, "congratulation !! Your Order Placed Successfully.")
  end

  def load_user_addresses
    @addresses = current_user.addresses
    unless @addresses.present?
      redirect_handler(current_user, "Please add a address")
    end
  end

  def update_stock
    unless @batch_order
      @product.quantity -= quantity.to_i
      @product.save
    end
  end

  def load_cart_and_products
    @cart = ShoppingCart.find_by(id:params[:cart_id])
    unless @cart.present?
      redirect_handler(shopping_cart_index_path, "Something went Wrong")
    end
    @cart_products = @cart.cart_products.all
    @order_list = @cart.cart_products.joins(:product).with_in_stock
  end

  def load_order_address
    @address = current_user.addresses.find_by(id: params[:address])
    unless @address.present?
      redirect_handler(shopping_cart_index_path, "Something went Wrong")
    end
  end

  def place_batch_order
    @order_list.each do |item|
      if (item.product.quantity >= item.quantity)
        @order = current_user.orders.new(address: @address, status:"In Process")
        @order.save
        @order_item = @order.order_items.create(product_id:item.product_id, quantity:item.quantity, price:item.total)
        item.product.quantity -= item.quantity.to_i
        item.product.save
        @cart_products.delete(item)
      end 
    end
  end

  def get_data_for_batch_order
    data_for_order_item =  params.require(:order).permit(:address, :cart_id, :batch_order).to_h
    @batch_order = data_for_order_item['batch_order']
    @address = data_for_order_item['address']
    @cart_id = data_for_order_item['cart_id']
    @address = data_for_order_item['address']
    @cart = ShoppingCart.find_by(id:@cart_id)
    if @batch_order
      @cart_products = @cart.cart_products.all
      @order_list = @cart.cart_products.joins(:product).with_in_stock
    end
  end

end
