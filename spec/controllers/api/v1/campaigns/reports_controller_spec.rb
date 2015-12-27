require 'rails_helper'

RSpec.describe Api::V1::Campaigns::ReportsController, type: :controller do

  describe "POST #create", :vcr do
    before :all do
    end

    context "when the user has not reported the campaign" do
      before do
        user = create :instagram_user
        campaign = create(:instagram_detail).campaign
        api_authorization_header user.auth_token
        post :create, { campaign_id: campaign.id }
      end

      it { is_expected.to respond_with :created }
    end

    context "when the user already reported the campaign" do
      before do
        user = create :instagram_user
        campaign = create(:instagram_detail).campaign
        api_authorization_header user.auth_token
        post :create, { campaign_id: campaign.id }
        post :create, { campaign_id: campaign.id }
      end
      
      it { is_expected.to respond_with :ok }
    end
  end

end
