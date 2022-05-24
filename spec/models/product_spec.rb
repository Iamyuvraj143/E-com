require 'rails_helper'

RSpec.describe Product, type: :model do
  
  describe 'associations' do
    it { should have_many_attached(:photos) }
    it { should have_many(:cart_products) }
    it { should have_many(:order_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:quantity) }
  end

  it do
    should validate_length_of(:description).
    is_at_least(100).
    on(:create)
  end

end
