class OrdersController < ApplicationController
  before_action :auth_check
  before_action :load_user_addresses,  only: %i(new)
  before_action :new_order_load, only: %i(new)
  before_action :check_product_stock, only: %i(new)
  after_action :update_stock, only: %i(create)
  before_action :create_order_essentials, only: %i(create)
  before_action :load_order, only: %i(edit update show)


  def index
    @orders = Current.user.orders.eager_load(:order_items)
  end

  def new
    @order = Current.user.orders.new
  end

  def show
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

  def create_order_essentials
    data_for_order_item =  params.require(:order).permit(:quantity, :product_id, :cart_id).to_h
    product_id = data_for_order_item['product_id']
    @quantity = data_for_order_item['quantity']
    @product = Product.find_by(id: product_id)

    unless @product.present?
      redirect_handler(root_path, "Something went Wrong :- Product does not exist.")
    end
    @cart_product = CartProduct.find_by(id:data_for_order_item['cart_id'])
    @total = @product.price * @quantity.to_f
  end

  def load_order
    @order = Current.user.orders.find_by(id: params[:id])
    unless @order.present?
      redirect_handler(root_path, "Something went Wrong :- Order does not exist.")
    end
  end

  def new_order_load
    @quantity =  params[:quantity]
    @product = Product.find_by(id: params[:product_id])
    unless @product.present?
      redirect_handler(root_path, "Something went Wrong :- Product does not exist.")
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
    @addresses = Current.user.addresses
    unless @addresses.present?
      redirect_handler(Current.user, "Please add a address")
    end
  end

  def update_stock
    @product.quantity -= @quantity.to_i
    @product.save
  end

end
