require 'rails_helper'

RSpec.describe Api::V1::CampaignsController, type: :controller do

  describe "GET #index", :vcr do
    context "when user has already created some campaigns" do
      before do
        user = create :user
        5.times do
          @last = create :instagram_liking_campaign, owner: user
        end
        api_authorization_header user.auth_token
        get :index
      end

      it "should return 5 records from database" do
        campaigns_response = json_response[:campaigns]
        expect(campaigns_response.size).to eql 5
      end

      it "consists of its attributes" do
        campaigns_response = json_response[:campaigns]
        expect(campaigns_response.first[:status]).to eql @last.status
        expect(campaigns_response.first[:payment_type]).to eql @last.campaign_class.payment_type
        expect(campaigns_response.first[:campaign_type]).to eql @last.campaign_type
      end

      it { should respond_with :ok }
    end

    context "when user has not created any campaign" do
      before do
        user = create :user
        api_authorization_header user.auth_token
        get :index
      end

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it "should return a 'no more campaigns' error" do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include I18n.t 'errors.messages.not_found'
      end

      it { should respond_with :not_found }
    end
  end

  describe "GET #next", :vcr do
    before do
      Campaign.all.each do |campaign|   # makes sure that there's no other campaign left to be liked
        campaign.destroy
      end
      @user = create :user
      @campaigns = []
      5.times do
        @campaigns << create(:instagram_liking_campaign)
      end
      api_authorization_header @user.auth_token
    end

    context "when user has already liked one of the campaigns" do
      before do
        @campaigns.first.liking_users << @user
        get :next
      end
      it "should return the next record" do
        campaign_response = json_response[:campaign]
        expect(campaign_response[:website]).to eql @campaigns[1].website
      end

      it { should respond_with :ok }
    end

    context "when user has liked all of the campaigns" do
      before do
        @campaigns.each { |c| c.liking_users << @user }
        get :next
      end

      it "should return a 'no more campaigns' error" do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include "مورد درخواست‌شده یافت نشد"
      end

      it { is_expected.to respond_with :not_found }
    end

  end

  describe "GET #new" do
    let(:user) { create :user }
    before do
      CampaignClass.all.each { |c| c.destroy }
      create :instagram_liking_like_class
      create :instagram_liking_coin_class
      api_authorization_header user.auth_token
      get :new
    end

    it "renders a json for all available prices" do
      expect(json_response).to have_key :campaign_classes
    end

    it "renders json representation of instagram_like price" do
      prices_response = json_response[:campaign_classes]
      expect(prices_response[0][:campaign_value]).to eql CampaignClass.where(campaign_type: "InstagramLikingCampaign",
                  payment_type: "like")
           .order(created_at: :desc).first.campaign_value
    end

    it "renders json representation of instagram_coin price" do
      prices_response = json_response[:campaign_classes]
      expect(prices_response[1][:campaign_value]).to eql CampaignClass.where(campaign_type: "InstagramLikingCampaign",
                  payment_type: "coin")
           .order(created_at: :desc).first.campaign_value
    end

    it { is_expected.to respond_with :ok }
  end

  describe "POST #create", :vcr do
    let(:user) { create :user }
    context "when is successfully created" do
      before do
        create :instagram_liking_like_class
        campaign_attributes = attributes_for(:instagram_liking_campaign, payment_type: 'like').merge({campaign_type: "instagram_liking"})
        api_authorization_header user.auth_token
        post :create, { campaign: campaign_attributes }
      end

      it { should respond_with :created }
    end

    context "when is not created" do
      context "when campaign_type field is empty" do
        before do
          invalid_campaign_attributes = attributes_for(:instagram_liking_campaign).except(:budget)
          api_authorization_header user.auth_token
          post :create, { campaign: invalid_campaign_attributes }
        end

        it "should render an errors json" do
          campaign_response = json_response
          expect(campaign_response).to have_key :errors
        end

        it "should render the json errors on why the user could not be created" do
          campaign_response = json_response
          expect(campaign_response[:errors][:budget]).to include I18n.t("errors.messages.not_a_number")
        end

        it { should respond_with :unprocessable_entity }
      end

      context "when the shortcode is invalid" do
        before do
          user = create :user
          invalid_campaign_attributes = attributes_for(:instagram_liking_campaign, target_url: "http://instagras.com/sdf/sdf").merge({campaign_type: "instagram_liking"})
          api_authorization_header user.auth_token
          post :create, { campaign: invalid_campaign_attributes }
        end

        it "should render an errors json" do
          campaign_response = json_response
          expect(campaign_response).to have_key :errors
        end

        it "should render the json errors on why the user could not be created" do
          campaign_response = json_response
          expect(campaign_response[:errors][:'target_url']).to include I18n.t "errors.messages.wrong_instagram_url"
        end

        it { should respond_with :unprocessable_entity }
      end
    end
  end

=begin
  describe "GET #show", :vcr do
    context "when the requested campaign is not available" do
      before do
        user = create :user
        api_authorization_header user.auth_token
        get :show, id: 35346854643
      end

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it 'returns not found error' do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include "مورد درخواست‌شده یافت نشد"
      end

      it { should respond_with :not_found }
    end

    context "when the requested campaign is available" do
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
        expect(campaigns_response[:value]).to eql instagram_detail.campaign.price.users_share
        expect(campaigns_response[:detail][:url]).to eql instagram_detail.url
      end

      it { should respond_with :ok }
    end
  end
  describe "PUT/PATCH #update", :vcr do
    before do
      owner = create :user
      @campaign = create :campaign, owner: owner
      create :instagram_detail, campaign: @campaign
      api_authorization_header owner.auth_token
    end

    context "when the requested campaign doesn't exist" do
      before do
        patch :update, { id: 235464, campaign: { instagram_detail_attributes: { url: "https://instagram.com/p/#{Rails.application.secrets.liked_instagram_shortcode}" } } }
      end

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it "should render the json errors on why the campaign could not be updated" do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include "مورد درخواست‌شده یافت نشد"
      end

      it { should respond_with :not_found }
    end

    context "when is successfully updated" do
      before do
        patch :update, { id: @campaign.id, campaign: { instagram_detail_attributes: { url: "https://instagram.com/p/#{Rails.application.secrets.liked_instagram_shortcode}" } } }
      end

      it "should render json representation for the updated campaign" do
        campaign_response = json_response[:campaign]
        expect(campaign_response[:campaign_type]).to eql @campaign.campaign_type
        expect(campaign_response[:instagram_detail][:url]).to eql "https://instagram.com/p/#{Rails.application.secrets.liked_instagram_shortcode}"
      end

      it { should respond_with :ok }
    end

    context "when there's an invalid parameter and it's not updated" do
      before do
        patch :update, { id: @campaign.id, campaign: { instagram_detail_attributes: { url: "https://instagram.com/p/dfsdgwtn4mtwmgfnkds" } } }
      end

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it "should render the json errors on why the campaign could not be updated" do
        campaign_response = json_response
        expect(campaign_response[:errors][:'instagram_detail.url']).to include "آدرس تصویر اینستاگرام اشتباه است"
      end

      it { should respond_with :unprocessable_entity }
    end
  end
=end
end
