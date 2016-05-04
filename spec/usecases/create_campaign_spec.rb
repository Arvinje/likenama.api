require 'rails_helper'

RSpec.describe CreateCampaign do

  describe '#save', :vcr do
    let(:user) { create :user, coin_credit: 100, like_credit: 100 }
    let(:params) { attributes_for(:instagram_liking_campaign, budget: 50, payment_type: "coin")
                    .except(:type, :status, :total_likes, :target)
                    .merge(campaign_type: "instagram_liking")
                  }
    let(:creation) { CreateCampaign.new(params,user) }
    before do
      allow(CampaignRegistry).to receive(:campaign_for).with(params[:campaign_type]).and_return InstagramLikingCampaign
      allow(creation.campaign).to receive(:fetch_cover).and_return(true)
    end
    before(:all) do
      create :instagram_liking_coin_class
    end

    context "when the input is valid" do
      before do
        validator = double(validate: true, campaign: creation.campaign)
        allow(creation.campaign).to receive(:creation_validator).and_return(validator)
      end

      it "returns true" do
        expect(creation.save).to be true
      end

      it "doesn't have any errors hash on campaign instance" do
        creation.save
        expect(creation.campaign.errors).to be_empty
      end

      it "withdraws the specified budget from owner's credit" do
        expect{ creation.save }.to change{ creation.campaign.owner.coin_credit }.by(-50)
        expect{ creation.save }.not_to change{ creation.campaign.owner.like_credit }
      end
    end

    context "when type-specific validations are failed" do
      before do
        campaign = creation.campaign
        campaign.errors.add(:target_url, :wrong_instagram_url)
        validator = double(validate: false, campaign: campaign)
        allow(creation.campaign).to receive(:creation_validator).and_return(validator)
      end

      it "returns false" do
        expect(creation.save).to be false
      end

      it "has some errors on campaign instance" do
        creation.save
        expect(creation.campaign.errors[:target_url]).to include I18n.t 'errors.messages.wrong_instagram_url'
      end
    end

    context "when campaign general validations are failed" do
      let(:params) { attributes_for(:instagram_liking_campaign, budget: 50, payment_type: "dollar_getter")
                      .except(:type, :status, :total_likes, :target)
                      .merge(campaign_type: "instagram_liking")
                    }
      before do
        validator = double(validate: true, campaign: creation.campaign)
        allow(creation.campaign).to receive(:creation_validator).and_return(validator)
      end

      it "returns false" do
        expect(creation.save).to be false
      end

      it "has some errors on campaign instance" do
        creation.save
        expect(creation.campaign.errors[:base]).to include I18n.t 'errors.messages.class_not_available'
      end
    end
  end

end
