require 'rails_helper'

INSTAGRAM_ACCESS_TOKEN = { instagram_access_token: Rails.application.secrets.access_token_no1 }
INVALID_INSTAGRAM_ACCESS_TOKEN = { instagram_access_token: "465469725.5106fe6.33df8ecbd624n8f8ee39638ffd2jc671" }

RSpec.describe InstagramOperator do
  describe "#call", :vcr do
    let(:user) { create :user }

    context "user has already liked the target" do
      let(:campaign) { create(:instagram_detail,
                              url: "https://instagram.com/p/#{Rails.application.secrets.liked_instagram_shortcode}").campaign }
      let(:liking) { CampaignLiking.new(campaign, user, INSTAGRAM_ACCESS_TOKEN) }

      it "returns true" do
        expect(liking.like!).to be true
      end
    end

    context "user has not liked the target" do
      let(:campaign) { create(:instagram_detail,
                              url: "https://instagram.com/p/#{Rails.application.secrets.not_liked_instagram_shortcode}").campaign }
      let(:liking) { CampaignLiking.new(campaign, user, INSTAGRAM_ACCESS_TOKEN) }

      it "returns false" do
        expect(liking.like!).to be false
      end

      it 'adds respective error to the campaign object' do
        liking.like!
        expect(liking.campaign.errors[:base]).to include I18n.t 'errors.messages.has_not_liked'
      end
    end

    context "the access_token is invalid" do
      let(:campaign) { create(:instagram_detail,
                              url: "https://instagram.com/p/#{Rails.application.secrets.liked_instagram_shortcode}").campaign }
      let(:liking) { CampaignLiking.new(campaign, user, INVALID_INSTAGRAM_ACCESS_TOKEN) }

      it "returns false" do
        expect(liking.like!).to be false
      end

      it 'adds respective error to the campaign object' do
        liking.like!
        expect(liking.campaign.errors[:base]).to include I18n.t 'errors.messages.access_token_invalid'
      end
    end

    context "when the target is not available anymore" do
      let(:detail) { create(:instagram_detail) }

      before do
        detail.short_code = "54Ie0JC6c0"
        detail.save(validate: false)
        campaign = detail.campaign
        @liking = CampaignLiking.new(campaign, user, INSTAGRAM_ACCESS_TOKEN)
      end

      it "returns false" do
        expect(@liking.like!).to be false
      end

      it 'adds respective error to the campaign object' do
        @liking.like!
        expect(@liking.campaign.errors[:base]).to include I18n.t 'errors.messages.deleted'
      end
    end
  end
end
