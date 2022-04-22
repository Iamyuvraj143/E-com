class User < ApplicationRecord
  # adds virtual attributes for authentication
  has_one :shopping_cart
  has_many :addresses, dependent: :destroy
  has_secure_password
  has_one_attached :avatar, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }
end
