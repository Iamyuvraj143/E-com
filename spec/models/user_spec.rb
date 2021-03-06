require 'rails_helper'

RSpec.describe User, type: :model do

  context 'before create' do
    it 'cannot have addresses' do
      expect { User.create.addresses.create! }.to raise_error(ActiveRecord::RecordNotSaved)  # test code
    end
  end


  it "is valid with valid attributes" do
    expect(User.new(email:"gfg@gmail.com", password:"123456789")).to be_valid
  end

  it "is not valid without a email" do
    user = User.new(email: nil)
    expect(user).to_not be_valid
  end

  describe 'associations' do
    it { should have_one(:shopping_cart) }
    it { should have_many(:addresses) }
    it { should have_one_attached(:avatar) }
  end

end
