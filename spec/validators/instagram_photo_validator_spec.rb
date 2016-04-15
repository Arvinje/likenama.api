require 'rails_helper'

RSpec.describe InstagramPhotoValidator do

  let(:validator) { InstagramPhotoValidator.new(campaign) }
  describe "#validate" do
    context "when it's a valid request" do
      let(:campaign) { build :instagram_liking_campaign, target_url: "http://instagram.com/p/***REMOVED***", target: nil}

      it "returns true" do
        expect(validator.validate).to be true
      end

      it "doesn't add any errors to the campaign instance" do
        expect(validator.campaign.errors[:target_url]).to be_empty
      end
    end

    context "when it's not a instagram url" do
      let(:campaign) { build :instagram_liking_campaign, target_url: "http://instagrams.com/p/***REMOVED***", target: nil}

      it "returns false" do
        expect(validator.validate).to be false
      end

      it "adds respective error to the campaign instance" do
        validator.validate
        expect(validator.campaign.errors[:target_url]).to include I18n.t 'errors.messages.wrong_instagram_url'
      end
    end

    context "when it's not a valid instagram short_code" do
      let(:campaign) { build :instagram_liking_campaign, target_url: "http://instagrams.com/p/54gBzGb6UK", target: nil}

      it "returns false" do
        expect(validator.validate).to be false
      end

      it "adds respective error to the campaign instance" do
        validator.validate
        expect(validator.campaign.errors[:target_url]).to include I18n.t 'errors.messages.wrong_instagram_url'
      end
    end
  end

end
