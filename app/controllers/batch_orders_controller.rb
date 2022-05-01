class BatchOrdersController < ApplicationController
  before_action :load_cart, only: %i(index , new)
  before_action :load_order_address, only: %i(index , new)
  before_action :remove_out_of_stock_item, only: %i(index , new)
  after_action :place_order, only: %i(new)

  def new; end

  def index
    @grand_total = 0
  end

  private

  def load_cart
    @cart = ShoppingCart.find_by(id:params[:cart_id])
    unless @cart.present?
      redirect_to shopping_cart_index_path
      flash[:notice] = "Something went Wrong"
    end
    @cart_products = @cart.cart_products
  end

  def place_order
    @order_list.each do |item|
      @order = Current.user.orders.new(address: @address, status:"In Process")
      @order.save
      @order_item = @order.order_items.create(product_id:item.product_id, quantity:item.quantity, price:item.total)
      item.product.quantity -= item.quantity.to_i
      item.product.save
      flash[:notice] = "congratulation !! Your Order Placed Successfully. "
      @cart_products.delete(item) 
    end
  end

  def remove_out_of_stock_item
   @cart_products = @cart.cart_products
   @order_list = Array.new
   @cart_products.each do |item|
      unless item.product.quantity < item.quantity 
         @order_list.push(item)
      end
    end
  end

  def load_order_address
    @address = Address.find_by(id: params[:address])
    unless @address.present?
      redirect_to shopping_cart_index_path
      flash[:notice] = "Something went Wrong"
    end
  end

end
