require 'rails_helper'

class Authentication < ActionController::Base
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe "#current_user" do
    before do
      @user = FactoryGirl.create :user
      request.headers["Authorization"] = @user.auth_token
      allow(authentication).to receive(:request).and_return(request)
    end

    it "returns the user from the authorization header" do
      expect(authentication.current_user.auth_token).to eql @user.auth_token
    end
  end

  describe "#authenticate_with_token" do
    context "when user exists and is not locked" do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user).and_return(nil)
        allow(response).to receive(:response_code).and_return(401)
        allow(response).to receive(:body).and_return({"errors" => { base: ["ارتباط با سرور قطع شده‌است. دوباره وارد شوید"] }}.to_json)
        allow(authentication).to receive(:response).and_return(response)
      end

      it "render a json error message" do
        expect(json_response[:errors][:base]).to include "ارتباط با سرور قطع شده‌است. دوباره وارد شوید"
      end

      it { should respond_with 401 }
    end
    context "when user exists but is locked" do
      let(:user) { create :user }
      before do
        user.lock_access!({ send_instructions: false })
        allow(authentication).to receive(:current_user).and_return(user)
        allow(response).to receive(:response_code).and_return(401)
        allow(response).to receive(:body).and_return({"errors" => { base: ["اکانت شما قفل شده‌است. برای اطلاعات بیشتر با پشتیبانی تماس بگیرید"] }}.to_json)
        allow(authentication).to receive(:response).and_return(response)
      end

      it "renders a json error message" do
        expect(json_response[:errors][:base]).to include "اکانت شما قفل شده‌است. برای اطلاعات بیشتر با پشتیبانی تماس بگیرید"
      end
    end
  end

  describe "#user_signed_in?" do
    context "when there is a user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user).and_return(@user)
      end

      it { should be_user_signed_in }
    end

    context "when there is no user on 'session'" do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user).and_return(nil)
      end

      it { should_not be_user_signed_in }
    end
  end

end
