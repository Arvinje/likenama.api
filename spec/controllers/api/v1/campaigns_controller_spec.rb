require 'rails_helper'

RSpec.describe Api::V1::CampaignsController, type: :controller do

  describe "GET #index" do
    context "when user has already created some campaigns" do
      before do
        user = create :user
        5.times do
          create :campaign, owner: user
        end
        api_authorization_header user.auth_token
        get :index
      end

      it "should return 5 records from database" do
        campaigns_response = json_response[:campaigns]
        expect(campaigns_response.size).to eql 5
      end

      it { should respond_with 200 }
    end

    context "when user has not created any campaign" do
      before do
        user = create :user
        api_authorization_header user.auth_token
        get :index
      end

      it "should return a 'no more campaigns' error" do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include "no available campaign"
      end

      it { should respond_with 422 }
    end
  end

  describe "GET #next" do
    before do
      Campaign.all.each do |campaign|   # makes sure that there's no other campaign left to be liked
        campaign.destroy
      end
      @user = create :user
      @campaigns = []
      5.times do
        @campaigns << create(:campaign)
      end
      api_authorization_header @user.auth_token
    end

    context "when user has already liked one of the campaigns" do
      before do
        @campaigns.first.like @user
        get :next
      end
      it "should return the next record" do
        campaign_response = json_response[:campaign]
        expect(campaign_response[:instagram_detail][:website]).to eql @campaigns[1].instagram_detail.website
      end

      it { should respond_with 200 }
    end

    context "when user has liked all of the campaigns" do
      before do
        @campaigns.each { |c| c.like @user }
        get :next
      end

      it "should return a 'no more campaigns' error" do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include "no available campaign"
      end
    end

  end

  describe "POST #create" do
    context "when is successfully created" do
      before do
        user = create :user
        instagram_detail_attributes = attributes_for :instagram_detail
        @campaign_attributes = attributes_for(:campaign).merge({instagram_detail_attributes: instagram_detail_attributes})
        api_authorization_header user.auth_token
        post :create, { campaign: @campaign_attributes }
      end

      it "should render json representation for the campaign just created" do
        campaign_response = json_response[:campaign]
        expect(campaign_response[:instagram_detail][:short_code]).to eql @campaign_attributes[:instagram_detail_attributes][:short_code]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      context "when campaign_type field is empty" do
        before do
          user = create :user
          @invalid_campaign_attributes = { payment_type: "money_getter" }
          api_authorization_header user.auth_token
          post :create, { campaign: @invalid_campaign_attributes }
        end

        it "should render an errors json" do
          campaign_response = json_response
          expect(campaign_response).to have_key :errors
        end

        it "should render the json errors on why the user could not be created" do
          campaign_response = json_response
          expect(campaign_response[:errors][:campaign_type]).to include "can't be blank"
        end

        it { should respond_with 422 }
      end

      context "when the shortcode is invalid" do
        before do
          user = create :user
          instagram_detail_attributes = attributes_for :instagram_detail, short_code: "erewtr45346Vcv"
          @invalid_campaign_attributes = attributes_for(:campaign).merge({instagram_detail_attributes: instagram_detail_attributes})
          api_authorization_header user.auth_token
          post :create, { campaign: @invalid_campaign_attributes }
        end

        it "should render an errors json" do
          campaign_response = json_response
          expect(campaign_response).to have_key :errors
        end

        it "should render the json errors on why the user could not be created" do
          campaign_response = json_response
          expect(campaign_response[:errors][:'instagram_detail.short_code']).to include "invalid shortcode"
        end

        it { should respond_with 422 }
      end
    end
  end

  describe "GET #show" do
    let(:campaign) { create :campaign }
    let(:instagram_detail) { create :instagram_detail, campaign: campaign }
    before do
      user = create :user
      api_authorization_header user.auth_token
      get :show, id: instagram_detail.campaign.id
    end

    it "should return the requested campaign" do
      campaigns_response = json_response[:campaign]
      expect(campaigns_response[:campaign_type]).to eql instagram_detail.campaign.campaign_type
      expect(campaigns_response[:instagram_detail][:short_code]).to eql instagram_detail.short_code
    end
    it { should respond_with 200 }
  end

  describe "PUT/PATCH #update" do
    before do
      owner = create :user
      @campaign = create :campaign, owner: owner
      create :instagram_detail, campaign: @campaign
      api_authorization_header owner.auth_token
    end

    context "when the requested campaign doesn't exist" do
      before do
        patch :update, { id: 235464, campaign: { instagram_detail_attributes: { short_code: Rails.application.secrets.liked_instagram_shortcode } } }
      end

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it "should render the json errors on why the campaign could not be updated" do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include "the requested campaign could not be found"
      end

      it { should respond_with 422 }
    end

    context "when is successfully updated" do
      before do
        patch :update, { id: @campaign.id, campaign: { instagram_detail_attributes: { short_code: Rails.application.secrets.liked_instagram_shortcode } } }
      end

      it "should render json representation for the updated campaign" do
        campaign_response = json_response[:campaign]
        expect(campaign_response[:campaign_type]).to eql @campaign.campaign_type
        expect(campaign_response[:instagram_detail][:short_code]).to eql Rails.application.secrets.liked_instagram_shortcode
      end

      it { should respond_with 200 }
    end

    context "when there's an invalid parameter and it's not updated" do
      before do
        patch :update, { id: @campaign.id, campaign: { instagram_detail_attributes: { short_code: "3434dfsrgsfb" } } }
      end

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it "should render the json errors on why the campaign could not be updated" do
        campaign_response = json_response
        expect(campaign_response[:errors][:'instagram_detail.short_code']).to include "invalid shortcode"
      end

      it { should respond_with 422 }
    end
  end
end
