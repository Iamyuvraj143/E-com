require 'rails_helper'

RSpec.describe Order, type: :model do

  context 'before create' do  
    it 'cannot have order item' do   
      expect { Order.create.order_items.create! }.to raise_error(ActiveRecord::RecordNotSaved)  # test code
    end
  end

  it "can not place without order address" do
    order = Order.new(address: nil)
    expect(order).to_not be_valid
  end

  describe 'associations' do
    it { should belong_to(:user).class_name('User') }
    it { should have_many(:order_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:address) }
  end

end
