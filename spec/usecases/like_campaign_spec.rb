require 'rails_helper'

RSpec.describe LikeCampaign do

  describe '#like!' do
    let(:user) { create :user }
    let(:campaign) { create :instagram_liking_campaign }
    let(:opts) { {access_token: "aer1245"} }
    let(:liking) { LikeCampaign.new(campaign, user, opts) }
    before do
      validator = double(validate: true, campaign: campaign)
      allow(campaign.liking_validator).to receive(:new).with(campaign, user, opts).and_return(validator)
    end

    context "when user successfully likes the campaign", :vcr do
      it "returns true" do
        expect(liking.like!).to be true
      end

      it "returns a campaign with no errors" do
        liking.like!
        expect(liking.campaign.errors.messages).not_to have_key :errors
      end

      it "adds the user to the campaign's backers" do
        liking.like!
        expect(liking.campaign.liking_users).to include user
      end

      it "increments total_likes by 1" do
        expect { liking.like! }.to change{ liking.campaign.total_likes }.by 1
      end
    end

    #============================ Validations =================================#

    context "when user has already liked the campaign", :vcr do
      before do
        user.liked_campaigns << campaign
      end

      it "returns true" do
        expect(liking.like!).to be true
      end
    end

    context "when the campaign has ended", :vcr do
      let(:campaign) { create :instagram_liking_campaign, status: 'ended' }

      it 'returns false' do
        expect(liking.like!).to be false
      end

      it 'adds a respective error to the campaign object' do
        liking.like!
        expect(liking.campaign.errors[:base]).to include I18n.t 'errors.messages.no_longer_available'
      end
    end

    context "when campaign is still pending", :vcr do
      let(:campaign) { create :instagram_liking_campaign, status: 'pending' }

      it 'returns false' do
        expect(liking.like!).to be false
      end

      it 'adds a respective error to the campaign object' do
        liking.like!
        expect(liking.campaign.errors[:base]).to include I18n.t 'errors.messages.not_verified'
      end
    end

    context "when it doesn't have enough budget even for a like", :vcr do
      let(:user) { create :user }
      let(:campaign) { create :instagram_liking_campaign, payment_type: "coin" }

      before do
        campaign.campaign_class = create :instagram_liking_coin_class
        campaign.budget = 4
        campaign.save
        @liking = LikeCampaign.new(campaign, user)
      end

      it 'returns false' do
        expect(@liking.like!).to be false
      end

      it 'adds a respective error to the campaign object', :vcr do
        @liking.like!
        expect(@liking.campaign.errors[:base]).to include I18n.t 'errors.messages.budget_run_out'
      end
    end

    context "when the duration between each user's like is not valid", :vcr do
      before do
        @user = create :user
        campaign = create :instagram_liking_campaign
        campaign.campaign_class = create :instagram_liking_coin_with_waiting_class
        campaign.save

        liking = LikeCampaign.new(campaign, @user)
        allow(liking).to receive(:validator_response).and_return(true)
        liking.like!
        campaign = create :instagram_liking_campaign
        @liking = LikeCampaign.new(campaign, @user)
        allow(@liking).to receive(:validator_response).and_return(true)
      end

      it 'returns false' do
        expect(@liking.like!).to be false
      end

      it 'adds a respective error to the campaign object' do
        @liking.like!
        expect(@liking.campaign.errors[:base]).to include I18n.t 'errors.messages.have_to_wait'
      end
    end

    #======================== Operator Response ===============================#

    context "when the response from the operator is false", :vcr do
      before do
        campaign.errors.add(:base, :has_not_liked)
        validator = double(validate: false, campaign: campaign)
        allow(campaign.liking_validator).to receive(:new).with(campaign, user, opts).and_return(validator)
      end

      it 'returns false' do
        expect(liking.like!).to be false
      end

      it 'adds a respective error to the campaign object' do
        liking.like!
        expect(liking.campaign.errors[:base]).to include I18n.t 'errors.messages.has_not_liked'
      end
    end

    #=========================== Credential Ops ===============================#
    context "when it's a like campaign", :vcr do
      let(:campaign) { create :instagram_liking_campaign, payment_type: 'like' }

      it 'returns true' do
        expect(liking.like!).to be true
      end

      it "increases user's like_credit by campaign's users_share" do
        expect{ liking.like! }.to change{ user.like_credit }.by campaign.campaign_class.like_user_share
      end

      it "decreases campaign's budget by its campaign_value"  do
        expect{ liking.like! }.to change{ campaign.budget }.by (campaign.campaign_class.campaign_value * -1)
      end
    end

    context "when it's a coin campaign", :vcr do
      let(:campaign) { create :instagram_liking_campaign, payment_type: 'coin' }

      it 'returns true' do
        expect(liking.like!).to be true
      end

      it "increases user's coin_credit by campaign's users_share" do
        expect{ liking.like! }.to change{ user.coin_credit }.by campaign.campaign_class.coin_user_share
      end

      it "decreases campaign's budget by its campaign_value"  do
        expect{ liking.like! }.to change{ campaign.budget }.by (campaign.campaign_class.campaign_value * -1)
      end
    end

    context "when campaign gets its last possible like", :vcr do
      let(:user1) { create :user }
      let(:user2) { create :user }
      let(:campaign_class) { create :instagram_liking_coin_class, campaign_value: 5, coin_user_share: 2 }
      let(:campaign) { create :instagram_liking_campaign, payment_type: 'coin', budget: 7, campaign_class: campaign_class }
      let(:liking1) { LikeCampaign.new(campaign, user1) }
      let(:liking2) { LikeCampaign.new(campaign, user2) }

      before do
        allow(liking1).to receive(:validator_response).and_return(true)
        allow(liking2).to receive(:validator_response).and_return(true)
      end

      it 'returns true for the first like and false for the second one' do
        expect(liking1.like!).to be true
        expect(liking2.like!).to be false
      end

      it "marks the campaign as `ended`" do
        liking1.like!
        liking2.like!
        expect(liking2.campaign.ended?).to be true
      end
    end


  end

end
