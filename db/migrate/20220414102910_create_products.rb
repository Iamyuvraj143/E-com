class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.integer :quantity
      t.text :description
      t.string :category
      t.string :image

      t.timestamps
    end
  end
end
