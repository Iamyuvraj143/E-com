class Product < ApplicationRecord

  has_many_attached :photos, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, format: { with: /\A(\$)?(\d+)(\.|,)?\d{0,2}?\z/ } 
  validates :quantity, presence: true, format: { with: /\A\d+\z/, message: "Integer only." }, length: { maximum: 3}
  validates :category, presence: true
  validates :description, presence: true, length: { minimum: 100 }

end
