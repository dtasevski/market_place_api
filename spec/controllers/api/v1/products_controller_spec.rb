require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do

  describe "GET #show" do
    before(:each) do
      @product = FactoryBot.create :product
      get :show, params: { id: @product.id }
    end

    it "returns information about a reporter on a hash" do
      expect(json_response[:title]).to eql @product.title
    end

    it { should respond_with 200 }
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryBot.create :product }
      get :index
    end

    it "returns 4 records from the database" do
      expect(json_response[:products].length).to eq(4)
    end

    it { should respond_with 200 }
  end

end
