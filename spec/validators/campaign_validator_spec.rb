require 'rails_helper'

RSpec.describe CampaignValidator do

  describe "#validate" do
    context "when the requested budget is bigger than user's credit" do
      context "when it's a money_getter campaign" do
        let(:user) { build :user, coin_credit: -1 }
        let(:campaign) { build :campaign, payment_type: 'money_getter', owner: user, budget: 15 }
        let(:validation) { CampaignValidator.new(campaign) }
        subject { validation.validate }

        it "returns respective error" do
          expect(validation.validate.errors[:budget]).to include I18n.t 'errors.messages.not_enough_credit'
        end

        it { is_expected.not_to be_valid }
      end

      context "when it's a like_getter campaign" do
        let(:user) { build :user, like_credit: -1 }
        let(:campaign) { build :campaign, payment_type: 'like_getter', owner: user, budget: 15 }
        let(:validation) { CampaignValidator.new(campaign) }
        subject { validation.validate }

        it "returns respective error" do
          expect(validation.validate.errors[:budget]).to include I18n.t 'errors.messages.not_enough_credit'
        end

        it { is_expected.not_to be_valid }
      end
    end

    context "when the requested budget is not enough even for a like" do
      let(:user) { create :user }
      let(:price) { create :price, payment_type: 'like_getter', campaign_type: 'instagram', campaign_value: 5 }
      let(:campaign) { build :campaign, payment_type: 'like_getter', budget: 4, price: price }
      let(:validation) { CampaignValidator.new(campaign) }
      subject { validation.validate }

      it "returns respective error" do
        expect(validation.validate.errors[:budget]).to include I18n.t 'errors.messages.need_more_budget'
      end

      it { is_expected.not_to be_valid }
    end
  end

end
