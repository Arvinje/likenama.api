require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe "POST #create" do
    context 'user has signed up before' do
      before do
        @user = create :instagram_user
        post :create, { user: { uid: @user.uid } }
      end

      it "returns user's auth_token" do
        session_response = json_response[:session]
        expect(session_response[:auth_token]).to eql @user.auth_token
      end

      it { is_expected.to respond_with 200 }
    end

    context 'user has not signed up before' do
      before do
        post :create, { user: { uid: "235536435234522426434" } }
      end

      it "renders a respective json error" do
        user_response = json_response
        expect(user_response[:errors][:base]).to include "user not registered"
      end

      it { is_expected.to respond_with 404 }
    end
  end
end
