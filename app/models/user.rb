class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_commit :create_shopping_cart
  has_one :shopping_cart, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

end
