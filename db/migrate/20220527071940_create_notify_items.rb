class CreateNotifyItems < ActiveRecord::Migration[6.1]
  def change
    create_table :notify_items do |t|
      t.string :email
      t.belongs_to :user
      t.belongs_to :product

      t.timestamps
    end
  end
end
