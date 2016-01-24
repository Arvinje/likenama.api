require 'rails_helper'

INSTAGRAM_ACCESS_TOKEN = { instagram_access_token: Rails.application.secrets.access_token_no1 }

RSpec.describe CampaignLiking do

  describe '#like!' do

    context "when user successfully likes the campaign", :vcr do
      let(:user) { create :user }
      let(:campaign) { create :campaign }
      let(:liking) { CampaignLiking.new(campaign, user, INSTAGRAM_ACCESS_TOKEN) }

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
    end

    #============================ Validations =================================#

    context "when user has already liked the campaign", :vcr do
      let(:user) { create :user }
      let(:campaign) { create :campaign }
      before do
        user.liked_campaigns << campaign
      end

      it "returns true" do
        liking = CampaignLiking.new(campaign, user)
        expect(liking.like!).to be true
      end
    end

    context "when campaign is not available", :vcr do
      let(:user) { create :user }
      let(:campaign) { create :campaign, available: nil }
      let(:liking) { CampaignLiking.new(campaign, user) }

      it 'returns false' do
        expect(liking.like!).to be false
      end

      it 'adds a respective error to the campaign object' do
        liking.like!
        expect(liking.campaign.errors[:base]).to include I18n.t 'errors.messages.no_longer_available'
      end
    end

    context "when it doesn't have enough budget even for a like", :vcr do
      let(:user) { create :user }

      before do
        campaign = create :campaign
        campaign.price = create :price, campaign_value: 10, users_share: 5
        campaign.budget = 7
        campaign.save
        @liking = CampaignLiking.new(campaign, user)
      end

      it 'returns false' do
        expect(@liking.like!).to be false
      end

      it 'adds a respective error to the campaign object', :vcr do
        @liking.like!
        expect(@liking.campaign.errors[:base]).to include I18n.t 'errors.messages.budget_run_out'
      end
    end

    context "when campaign is not verified", :vcr do
      let(:user) { create :user }
      let(:campaign) { create :campaign, verified: nil }
      let(:liking) { CampaignLiking.new(campaign, user) }

      it 'returns false' do
        expect(liking.like!).to be false
      end

      it 'adds a respective error to the campaign object' do
        liking.like!
        expect(liking.campaign.errors[:base]).to include I18n.t 'errors.messages.not_verified'
      end
    end

    context "when the duration between each user's like is not valid", :vcr do
      before do
        @user = create :user
        campaign = create :campaign
        create :waiting, period: 10,
                          campaign_type: campaign.campaign_type,
                          payment_type: campaign.payment_type
        campaign.save
        CampaignLiking.new(campaign, @user, INSTAGRAM_ACCESS_TOKEN).like!
        campaign = create :campaign
        @liking = CampaignLiking.new(campaign, @user, INSTAGRAM_ACCESS_TOKEN)
      end

      it 'returns false' do
        allow(@liking).to receive(:operator_response).and_return(true)
        expect(@liking.like!).to be false
      end

      it 'adds a respective error to the campaign object' do
        @liking.like!
        expect(@liking.campaign.errors[:base]).to include I18n.t 'errors.messages.have_to_wait'
      end
    end

    #======================== Operator Response ===============================#

    context "when the response from the operator is false", :vcr do
      let(:user) { create :user }
      let(:campaign) { create :campaign }
      let(:liking) { CampaignLiking.new(campaign, user) }

      it 'returns false' do
        expect(liking.like!).to be false
      end

      it 'adds a respective error to the campaign object' do
        liking.like!
        expect(liking.campaign.errors[:base]).to include I18n.t 'errors.messages.has_not_liked'
      end
    end

    #=========================== Credential Ops ===============================#

    context "when it's a like_getter campaign", :vcr do
      let(:user) { create :user }
      let(:campaign) { create :campaign, payment_type: 'like_getter' }
      let(:liking) { CampaignLiking.new(campaign, user, INSTAGRAM_ACCESS_TOKEN) }

      it 'returns true' do
        expect(liking.like!).to be true
      end

      it "increases user's like_credit by campaign's users_share" do
        expect{ liking.like! }.to change{ user.like_credit }.by campaign.price.users_share
      end

      it "decreases campaign's budget by its campaign_value"  do
        expect{ liking.like! }.to change{ campaign.budget }.by (campaign.price.campaign_value * -1)
      end
    end

    context "when it's a money_getter campaign", :vcr do
      let(:user) { create :user }
      let(:campaign) { create :campaign, payment_type: 'money_getter' }
      let(:liking) { CampaignLiking.new(campaign, user, INSTAGRAM_ACCESS_TOKEN) }

      it 'returns true' do
        expect(liking.like!).to be true
      end

      it "increases user's coin_credit by campaign's users_share" do
        expect{ liking.like! }.to change{ user.coin_credit }.by campaign.price.users_share
      end

      it "decreases campaign's budget by its campaign_value"  do
        expect{ liking.like! }.to change{ campaign.budget }.by (campaign.price.campaign_value * -1)
      end
    end

    context "when campaign gets its last possible like", :vcr do
      let(:user1) { create :user }
      let(:user2) { create :user }
      let(:price) { create :price, campaign_type: 'instagram', payment_type: 'money_getter', campaign_value: 10, users_share: 5 }
      let(:campaign) { create :campaign, campaign_type: 'instagram', payment_type: 'money_getter', budget: 17, price: price }
      let(:liking1) { CampaignLiking.new(campaign, user1, INSTAGRAM_ACCESS_TOKEN) }
      let(:liking2) { CampaignLiking.new(campaign, user2, INSTAGRAM_ACCESS_TOKEN) }

      it 'returns true for the first like and false for the second one' do
        expect(liking1.like!).to be true
        expect(liking2.like!).to be false
      end

      it "marks campaign availability as false" do
        liking1.like!
        liking2.like!
        expect(liking2.campaign.available).to be false
      end
    end


  end

end
