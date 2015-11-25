require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "GET #self" do
    let(:user) { create :user, username: "phoebe_buffay" }
    before do
      api_authorization_header user.auth_token
      get :self
    end

    it "renders json representation of the logged in user" do
      user_response = json_response[:user]
      expect(user_response[:username]).to eql user.username
    end

    it { is_expected.to respond_with 200 }
  end
end
