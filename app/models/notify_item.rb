class NotifyItem < ApplicationRecord
  belongs_to :user
  belongs_to :product
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :with_product_id, ->(product_id) { where('product_id =?', product_id) }
end
