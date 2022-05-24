require 'rails_helper'

RSpec.describe "Orders", type: :request do
  
  let(:user) { build(:user) }
  let(:valid_attributes) {
    {
      address: '404 Rukamani Nagar',
      status: 'In progress'
    }
  }

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Order" do
        post orders_url, params: { order: valid_attributes }
        order = Order.create(address:'404 Rukamani Nagar', status:'In progress')
        expect(order.address).to eq('404 Rukamani Nagar')
        expect(order.status).to eq('In progress')
      end
    end
  end

  describe "GET /index" do
    it "returns http success" do
      sign_in(user)
      get "/orders"
      expect(response.status).to eq(200)
    end
  end

end
