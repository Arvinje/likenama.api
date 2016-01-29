require 'rails_helper'

RSpec.describe InstagramOperator do
  describe "#liked?", :vcr do
    let(:user) { create :user }

    context "user has already liked the target" do
      let(:campaign) { create(:instagram_detail,
                              short_code: Rails.application.secrets.liked_instagram_shortcode).campaign }
      let(:operator) { InstagramOperator.new(campaign: campaign, user: user, options: INSTAGRAM_ACCESS_TOKEN) }

      it "returns true" do
        expect(operator.liked?).to be true
      end
    end

    context "user has not liked the target" do
      let(:campaign) { create(:instagram_detail,
                              short_code: Rails.application.secrets.not_liked_instagram_shortcode).campaign }
      let(:operator) { InstagramOperator.new(campaign: campaign, user: user, options: INSTAGRAM_ACCESS_TOKEN) }

      it "returns false" do
        expect(operator.liked?).to be false
      end

      it 'adds respective error to the campaign object' do
        operator.liked?
        expect(operator.campaign.errors[:base]).to include I18n.t 'errors.messages.has_not_liked'
      end
    end

    context "the access_token is invalid" do
      let(:campaign) { create(:instagram_detail,
                              short_code: Rails.application.secrets.liked_instagram_shortcode).campaign }
      let(:operator) { InstagramOperator.new(campaign: campaign, user: user, options: INVALID_INSTAGRAM_ACCESS_TOKEN) }

      it "returns false" do
        expect(operator.liked?).to be false
      end

      it 'adds respective error to the campaign object' do
        operator.liked?
        expect(operator.campaign.errors[:base]).to include I18n.t 'errors.messages.access_token_invalid'
      end
    end

    context "when the target is not available anymore" do
      let(:detail) { create(:instagram_detail) }

      before do
        detail.short_code = "54Ie0JC6c0"
        detail.save(validate: false)
        campaign = detail.campaign
        @operator = InstagramOperator.new(campaign: campaign, user: user, options: INSTAGRAM_ACCESS_TOKEN)
      end

      it "returns false" do
        expect(@operator.liked?).to be false
      end

      it 'adds respective error to the campaign object' do
        @operator.liked?
        expect(@operator.campaign.errors[:base]).to include I18n.t 'errors.messages.deleted'
      end
    end
  end

  describe "#valid?", :vcr do
    context "it's a valid Instagram detail" do
      let(:detail) { build :instagram_detail }
      let(:operator) { InstagramOperator.new(detail: detail) }

      it "returns true" do
        expect(operator.valid?).to be true
      end

      it "doen't add any errors to the detail object" do
        operator.valid?
        expect(operator.detail.errors.blank?).to be true
      end
    end

    context "it has an invalid url" do
      let(:detail) { build :instagram_detail, url: "http://google.com/p/#{Rails.application.secrets.liked_instagram_shortcode}" }
      let(:operator) { InstagramOperator.new(detail: detail) }

      it "returns false" do
        expect(operator.valid?).to be false
      end

      it "adds respective errors to the detail object" do
        operator.valid?
        expect(operator.detail.errors[:url]).to include I18n.t 'errors.messages.wrong_instagram_url'
      end
    end

    context "it has an invalid shortcode" do
      let(:detail) { build :instagram_detail, url: "http://instagram.com/p/590QzGi0Zx" }
      let(:operator) { InstagramOperator.new(detail: detail) }

      it "returns false" do
        expect(operator.valid?).to be false
      end

      it "adds respective errors to the detail object" do
        operator.valid?
        expect(operator.detail.errors[:url]).to include I18n.t 'errors.messages.wrong_instagram_url'
      end
    end

  end
end
