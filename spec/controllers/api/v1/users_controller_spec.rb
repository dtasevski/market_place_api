require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe "GET#show" do
    before(:each) do
      @user = FactoryBot.create(:user)
      get :show, params: { id: @user.id }
    end

    it "returns information about a reporter on a hash" do
      expect(json_response[:user][:email]).to eql(@user.email)
    end

    it "has the product ids as embedded object" do
      expect(json_response[:user][:product_ids]).to eql []
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do

    context "when its successfully created" do
      before(:each) do
        @user_attributes = FactoryBot.attributes_for(:user)
        post :create, params: { user: @user_attributes }
      end

      it "renders the json representation for the user record just created" do
        expect(json_response[:user][:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when its not created" do
      before(:each) do
        @invalid_user_attributes = { password: "123456780", password_confirmation: "12345678"}
        post :create, params: { user: @invalid_user_attributes }
      end

      it "renders an errors json" do
        expect(json_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        expect(json_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PATCH #update" do

    context "when its successfully updated" do
      before(:each) do
        @user = FactoryBot.create :user
        api_authorization_header(@user.auth_token)
        patch :update, params: { id: @user.id,
                                       user: { email: "newmail@example.com"} }
      end

      it "renders the json representation of the updated user" do
        expect(json_response[:user][:email]).to eql "newmail@example.com"
      end

      it { should respond_with 200 }
    end

    context "when its not successfully updated" do
      before(:each) do
        @user = FactoryBot.create :user
        api_authorization_header(@user.auth_token)
        patch :update, params: { id: @user.id,
                                        user: { email: "bademail.com" } }
      end

      it "renders an error json" do
        expect(json_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be updated" do
        expect(json_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryBot.create :user
      api_authorization_header(@user.auth_token)
      delete :destroy, params: { id: @user.id }
    end

    it { should respond_with 204 }
  end
end
