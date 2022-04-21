class RemoveImageUrlColumn < ActiveRecord::Migration[6.1]
  def change
     remove_column :users, :image, :string
     remove_column :products, :image, :string
  end
end
