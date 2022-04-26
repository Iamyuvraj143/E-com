class CreateCartProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :cart_products do |t|
      t.integer :quantity
      t.float :cart_product_total
      t.belongs_to :product
      t.belongs_to :shopping_cart
      t.timestamps
    end
  end
end
