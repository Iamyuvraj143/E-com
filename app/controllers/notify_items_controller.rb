class NotifyItemsController < ApplicationController
  def new
    @product_id = params[:product_id]
    @notify_item = NotifyItem.new
  end

  def create
    @notify_item = NotifyItem.create(notify_item_params)
    respond_to do |format|
      if @notify_item.save
        # format.html { redirect_to shopping_cart_index_path, notice: 'Added to cart' }
        format.js
        format.json { render json: @cart_product, status: :created, location: root_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @notify_item.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def notify_item_params
    params.require(:notify_item).permit(:product_id, :email, :user_id)
  end
end
