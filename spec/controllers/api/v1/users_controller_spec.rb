require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "GET #self" do
    let(:user) { create :user }
    before do
      api_authorization_header user.auth_token
      get :self
    end

    it "renders json representation of the logged in user" do
      user_response = json_response[:user]
      expect(user_response[:uid]).to eql user.uid
    end

    it { is_expected.to respond_with 200 }
  end
end
