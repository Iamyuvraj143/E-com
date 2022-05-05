class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_shopping_cart
  after_save :send_welcome_mail
  has_one :shopping_cart, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy

  #validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

  def send_welcome_mail
    SendWelcomeEmailToNewUserJob.perform_now(self.email)
  end
end
