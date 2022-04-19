class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :address_line
      t.string :city
      t.string :state
      t.string :country
      t.integer :zipcode
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
