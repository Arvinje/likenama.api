require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do

  describe "POST #create", :vcr do
    let(:user) { create :user }

    context "when the user has provided a valid content" do
      let(:message) { attributes_for(:message).except(:read) }
      before do
        api_authorization_header user.auth_token
        post :create, { message: message }
      end

      it { is_expected.to respond_with :created }
    end

    context "when the content is not valid" do
      let(:message) { attributes_for(:invalid_message).except(:read) }
      before do
        api_authorization_header user.auth_token
        post :create, { message: message }
      end

      it "has an errors json" do
        expect(json_response[:errors][:content]).to include I18n.t 'errors.messages.too_long', count: 500
      end

      it { is_expected.to respond_with :unprocessable_entity }
    end

    context "when the email is not valid" do
      let(:message) { attributes_for(:message, email: 'goo@ggg').except(:read) }
      before do
        api_authorization_header user.auth_token
        post :create, { message: message }
      end

      it "has an errors json" do
        expect(json_response[:errors][:email]).to include I18n.t 'errors.messages.invalid', count: 500
      end

      it { is_expected.to respond_with :unprocessable_entity }
    end
  end

end
