require 'rails_helper'

RSpec.describe Api::V1::Campaigns::ReportsController, type: :controller do

  describe "POST #create", :vcr do
    let(:user) { create :user }
    let(:campaign) { create :instagram_liking_campaign }
    before do
      api_authorization_header user.auth_token
      post :create, { campaign_id: campaign.id }
    end

    context "when the user has not reported the campaign" do
      it { is_expected.to respond_with :created }
    end

    context "when the user already reported the campaign" do
      before do
        post :create, { campaign_id: campaign.id }
      end

      it { is_expected.to respond_with :ok }
    end
  end

end
