require 'rails_helper'

RSpec.describe Api::V1::LikesController, type: :controller do

  before do
    allow(KeyValue).to receive(:instagram_money_getter_value).and_return(2)
    allow(KeyValue).to receive(:instagram_like_getter_value).and_return(1)
  end

  describe "POST #create" do
    let(:user) { create :user }
    before do
      @campaign = create :campaign
      create :instagram_detail, campaign: @campaign, short_code: Rails.application.secrets.liked_instagram_shortcode
      api_authorization_header user.auth_token
    end

    context "when the post get liked successfully" do
      before do
        post :create, { campaign_id: @campaign.id, like: { instagram_access_token: Rails.application.secrets.access_token_no1 } }
      end

      it "should like the specified campaign" do
        expect(@campaign.liked_by? user).to eql true
      end

      it "should render the modified user details" do
        campaign_response = json_response
        expect(campaign_response[:user][:uid]).to eql user.uid
      end

      it { should respond_with 201 }
    end

    context "when user has not liked the photo" do
      before do
        @campaign = create :campaign
        create :instagram_detail, campaign: @campaign, short_code: Rails.application.secrets.not_liked_instagram_shortcode
        post :create, { campaign_id: @campaign.id, like: { instagram_access_token: Rails.application.secrets.access_token_no1 } }
      end

      it "should have not liked the campaign" do
        expect(@campaign.liked_by? user).to eql false
      end

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it "should provide the reason of the error" do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include "user has not liked the photo"
      end

      it { should respond_with 422 }
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
        expect(campaign_response[:errors][:base]).to include "the requested campaign could not be found"
      end

      it { should respond_with 422 }
    end
  end
end
