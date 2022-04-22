class CreateShoppingCarts < ActiveRecord::Migration[6.1]
  def change
    create_table :shopping_carts do |t|
      t.belongs_to :user,  index: { unique: true }, foreign_key: true
      t.timestamps
    end
  end
end
