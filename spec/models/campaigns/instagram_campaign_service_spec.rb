require 'rails_helper'

RSpec.describe InstagramCampaignService, type: :model do
  it_behaves_like "a campaign", :instagram_liking_campaign

  describe '#target_url' do
    context "when @target_url is available itself" do
      let(:campaign) { build :instagram_campaign_service, target: "bye", target_url: "http://instagram.com/p/hello" }

      it "returns the predefined target_url" do
        expect(campaign.target_url).to eql "http://instagram.com/p/hello"
      end
    end

    context "when target_url is not generated yet" do
      let(:campaign) { create :instagram_campaign_service, target: "bye", target_url: nil }

      it "returns the predefined target_url" do
        expect(campaign.target_url).to eql "http://instagram.com/p/bye"
      end
    end
  end
end
