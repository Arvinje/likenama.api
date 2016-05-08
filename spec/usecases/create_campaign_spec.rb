require 'rails_helper'

RSpec.describe CreateCampaign do

  describe '#save', :vcr do
    let(:user) { create :user, coin_credit: 100, like_credit: 100 }
    let(:campaign_class) { create :instagram_liking_coin_class }
    let(:params) { attributes_for(:instagram_liking_campaign, budget: 50)
                    .except(:payment_type, :type, :status, :total_likes, :target)
                    .merge(campaign_class_id: campaign_class.id)
                  }
    let(:creation) { CreateCampaign.new(params, campaign_class,user) }
    before do
      allow(creation.campaign).to receive(:fetch_cover).and_return(true)
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
      let(:params) { attributes_for(:instagram_liking_campaign, budget: 0)
                      .except(:payment_type, :type, :status, :total_likes, :target)
                      .merge(campaign_class_id: campaign_class.id)
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
        expect(creation.campaign.errors[:budget]).to include I18n.t 'errors.messages.need_more_budget'
      end
    end
  end

end
