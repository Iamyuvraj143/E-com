class Address < ApplicationRecord
  belongs_to :user
  validates :address_line, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true, format: { with: /\A\d+\z/, message: "Integer only. No sign allowed." }, length: {minimum: 4, maximum: 6}
  validates :country, presence: true
end
