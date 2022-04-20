class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true, format: { with: /\A(\$)?(\d+)(\.|,)?\d{0,2}?\z/ } 
  validates :quantity, presence: true, format: { with: /\A\d+\z/, message: "Integer only." }, length: { maximum: 3}
  validates :image, presence: true
  validates :category, presence: true
  validates :description, presence: true, length: { minimum: 100 }
end
