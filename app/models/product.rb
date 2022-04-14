class Product < ApplicationRecord
	validates :name, presence: true
	validates :price, presence: true
	validates :quantity, presence: true
	validates :image, presence: true
	validates :category, presence: true
  validates :description, presence: true, length: { minimum: 100 }
end
