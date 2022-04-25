class CartProduct < ApplicationRecord
  belongs_to :shopping_cart
  belongs_to :product

  validates :quantity, presence: true, 
                      length: {minimum: 1, maximum: 2},
                      numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  
end
