class User < ApplicationRecord

  after_commit :create_shopping_cart, on: :create

  has_one :shopping_cart, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_secure_password
  has_one_attached :avatar, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

  private

  def create_shopping_cart
    ShoppingCart.create(user_id: self.id)
  end

end
