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

      it { is_expected.to respond_with :created }
    end

    context 'user has not signed up before' do
      before do
        post :create, { user: { uid: "235536435234522426434" } }
      end

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it "should render the json errors on why the user could not be created" do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include "the requested record(s) cannot be found"
      end

      it { is_expected.to respond_with :not_found }
    end
  end
end
