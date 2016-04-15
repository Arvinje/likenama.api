require 'rails_helper'

RSpec.describe InstagramLikeValidator do
  describe "#validate", :vcr do
    let(:user) { create :user }

    context "user has already liked the target" do
      let(:campaign) { create :instagram_liking_campaign }
      let(:validator) { InstagramLikeValidator.new(campaign, user, INSTAGRAM_ACCESS_TOKEN) }

      it "returns true" do
        expect(validator.validate).to be true
      end
    end

    context "user has not liked the target" do
      let(:campaign) { create :instagram_liking_campaign,
                              target: Rails.application.secrets.not_liked_instagram_shortcode }
      let(:validator) { InstagramLikeValidator.new(campaign, user, INSTAGRAM_ACCESS_TOKEN) }

      it "returns false" do
        expect(validator.validate).to be false
      end

      it 'adds respective error to the campaign object' do
        validator.validate
        expect(validator.campaign.errors[:base]).to include I18n.t 'errors.messages.has_not_liked'
      end
    end

    context "the access_token is invalid" do
      let(:campaign) { create :instagram_liking_campaign,
                              target: Rails.application.secrets.liked_instagram_shortcode }
      let(:validator) { InstagramLikeValidator.new(campaign, user, INVALID_INSTAGRAM_ACCESS_TOKEN) }

      it "returns false" do
        expect(validator.validate).to be false
      end

      it 'adds respective error to the campaign object' do
        validator.validate
        expect(validator.campaign.errors[:base]).to include I18n.t 'errors.messages.access_token_invalid'
      end
    end

    context "when the target is not available anymore" do
      let(:campaign) { create :instagram_liking_campaign }
      before do
        campaign.target = "54Ie0JC6c0"
        campaign.save(validate: false)
        @validator = InstagramLikeValidator.new(campaign, user, INSTAGRAM_ACCESS_TOKEN)
      end

      it "returns false" do
        expect(@validator.validate).to be false
      end

      it "marks the campaign for checking and takes it down" do
        @validator.validate
        expect(@validator.campaign.check_needed?).to be true
      end

      it 'adds respective error to the campaign object' do
        @validator.validate
        expect(@validator.campaign.errors[:base]).to include I18n.t 'errors.messages.deleted'
      end
    end
  end
end
