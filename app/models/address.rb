class Address < ApplicationRecord
  belongs_to :user
  validates :address_line, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true
  validates :country, presence: true
end
