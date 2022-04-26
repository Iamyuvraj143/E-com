class ChangeColumanForCartProduct < ActiveRecord::Migration[6.1]
  def change
    rename_column :cart_products, :cart_product_total, :total
  end
end
