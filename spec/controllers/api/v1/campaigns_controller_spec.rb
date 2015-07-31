require 'rails_helper'

RSpec.describe Api::V1::CampaignsController, type: :controller do
  describe "GET #index" do
    before do
      user = create :user
      5.times { create :campaign }
      api_authorization_header user.auth_token
      get :index
    end

    it "should return 5 records from database" do
      campaigns_response = json_response
      expect(campaigns_response.size).to eql 5
    end
    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before do
        user = create :user
        instagram_detail_attributes = attributes_for :instagram_detail
        @campaign_attributes = attributes_for(:campaign).merge({instagram_detail_attributes: instagram_detail_attributes})
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, campaign: @campaign_attributes }
      end

      it "should render json representation for the campaign just created" do
        campaign_response = json_response
        expect(campaign_response[:like_value]).to eql @campaign_attributes[:like_value]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before do
        user = create :user
        @invalid_campaign_attributes = { campaign_type: "money_getter" }
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, campaign: @invalid_campaign_attributes }
      end

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it "should render the json errors on why the user could not be created" do
        campaign_response = json_response
        expect(campaign_response[:errors][:like_value]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "GET #show" do
    let(:campaign) { create :campaign }
    before do
      user = create :user
      api_authorization_header user.auth_token
      get :show, id: campaign.id
    end

    it "should return the requested campaign" do
      campaigns_response = json_response
      expect(campaigns_response[:like_value]).to eql campaign.like_value
    end
    it { should respond_with 200 }
  end
end
