require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do

  describe "GET #index " do
    before(:each) do
      current_user = FactoryBot.create :user
      api_authorization_header current_user.auth_token
      4.times { FactoryBot.create :order, user: current_user }
      get :index, params: { user_id: current_user.id }
    end

    it "returns 4 order records from the user" do
      expect(json_response[:orders].count).to eq(4)
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      current_user = FactoryBot.create :user
      api_authorization_header current_user.auth_token
      @product = FactoryBot.create :product
      @order = FactoryBot.create :order, user: current_user, product_ids: [ @product.id ]
      get :show, params: { user_id: current_user.id, id: @order.id }
    end

    it "returns the user order matching the id " do
      expect(json_response[:order][:id]).to eql @order.id
    end

    it "includes the total for the order" do
      expect(json_response[:order][:total]).to eql @order.total.to_s
    end

    it "includes the products on the order " do
      expect(json_response[:order][:products].count).to eq(1)
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    before(:each) do
      current_user = FactoryBot.create :user
      api_authorization_header current_user.auth_token
      product_1 = FactoryBot.create :product
      product_2 = FactoryBot.create :product
      order_params = { product_ids: [ product_1.id, product_2.id] }
      post :create, params: { user_id: current_user.id, order: order_params }
    end

    it "returns just the user order record" do
      expect(json_response[:order][:id]).to be_present
    end

    it { should respond_with 201 }
  end

end
