require 'rails_helper'

RSpec.describe Api::V1::Campaigns::LikesController, type: :controller do

  describe "POST #create", :vcr do
    let(:user) { create :user }
    let(:campaign) { create :campaign }
    before do
      api_authorization_header user.auth_token
    end

    context "when the post get liked successfully" do
      before do
        post :create, { campaign_id: campaign.id, like: { instagram_access_token: Rails.application.secrets.access_token_no1 } }
      end

      it "should like the specified campaign" do
        expect(campaign.liked_by? user).to eql true
      end

      it "should render the modified user details" do
        campaign_response = json_response
        expect(campaign_response[:user][:username]).to eql user.username
      end

      it { should respond_with :created }
    end

    context "when user has not liked the photo" do
      let(:campaign) { create :campaign }
      before do
        detail = campaign.detail
        detail.short_code = Rails.application.secrets.not_liked_instagram_shortcode
        detail.save
        post :create, { campaign_id: campaign.id, like: { instagram_access_token: Rails.application.secrets.access_token_no1 } }
      end

      it "should have not liked the campaign" do
        expect(campaign.liked_by? user).to eql false
      end

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it "should provide the reason of the error" do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include I18n.t :'errors.messages.has_not_liked'
      end

      it { should respond_with :unprocessable_entity }
    end

    context "when the campaign_id is not valid" do
      before do
        post :create, { campaign_id: 346734, like: { instagram_access_token: Rails.application.secrets.access_token_no1 } }
      end

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it "should provide the reason of the error" do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include "مورد درخواست‌شده یافت نشد"
      end

      it { should respond_with :not_found }
    end

    context "when the instagram_access_token is not valid" do
      before do
        post :create, { campaign_id: campaign.id, like: { instagram_access_token: "325fzdvfshgdhwrrehdfv4" } }
      end

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it "should provide the reason of the error" do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include I18n.t 'errors.messages.access_token_invalid'
      end

      it { should respond_with :unauthorized }
    end
  end
end
