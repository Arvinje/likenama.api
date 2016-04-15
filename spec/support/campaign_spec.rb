require 'rails_helper'

RSpec.shared_examples "a campaign" do |campaign_type|

  it { is_expected.to respond_to :budget }
  it { is_expected.to respond_to :payment_type }
  it { is_expected.to respond_to :owner }
  it { is_expected.to respond_to :price }
  it { is_expected.to respond_to :waiting }
  it { is_expected.to respond_to :total_likes }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :budget }
    it { is_expected.to validate_presence_of :payment_type }
    it { is_expected.to validate_presence_of :owner }

    it { is_expected.to validate_numericality_of(:budget).is_greater_than_or_equal_to(0).only_integer }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to have_many(:likes).dependent :destroy }
    it { is_expected.to have_many(:liking_users).through(:likes).source(:user) }
    it { is_expected.to belong_to(:owner).class_name('User') }
    it { is_expected.to belong_to(:price) }
    it { is_expected.to belong_to(:waiting) }
    it { is_expected.to have_many(:reports).dependent :destroy }
    it { is_expected.to have_many(:reporters).through(:reports).source(:user) }
  end

  describe "Callbacks", :vcr do
    let(:campaign) { build campaign_type }

    it { expect(campaign).to callback(:set_price).before(:create) }
    it { expect(campaign).to callback(:set_waiting).before(:create) }
  end

  describe "#verify!", :vcr do
    let(:campaign) { create campaign_type, status: 'pending' }
    before do
      campaign.verify!
      campaign.reload
    end

    it "sets the campaign available" do
      expect(campaign.available?).to eql true
    end
  end

  describe "#reject!", :vcr do
    context "on each type of campaign" do
      let(:campaign) { create campaign_type, status: 'pending' }
      before do
        campaign.reject!
        campaign.reload
      end

      it "sets the campaign rejected" do
        expect(campaign.rejected?).to be true
      end
    end
    context "when it's a like_getter campaign" do
      before do
        @owner = create :user, like_credit: 400
        @campaign = create campaign_type, status: 'pending', payment_type: "like_getter", budget: 100, owner: @owner
        @campaign.reject!
        @campaign.reload
      end

      it "returns the budget back to the owner's account" do
        expect(@campaign.owner.like_credit).to eql 500
      end
    end
    context "when it's a money_getter campaign" do
      before do
        @owner = create :user, coin_credit: 300
        @campaign = create campaign_type, status: 'pending', payment_type: "money_getter", budget: 100, owner: @owner
        @campaign.reject!
        @campaign.reload
      end

      it "returns the budget back to the owner's account" do
        expect(@campaign.owner.coin_credit).to eql 400
      end
    end
  end

  describe "#set_waiting", :vcr do
    context "it's an instagram campaign" do
      context "it's a money_getter campaign" do
        let(:campaign) { build campaign_type, payment_type: 'money_getter' }

        it "assigns the respective waiting to the campaign" do
          campaign.save
          expect(campaign.waiting.period).to eql Waiting.where(campaign_type: 'InstagramLikingCampaign', payment_type: 'money_getter').last.period
        end
      end
    end
  end

  describe "#for_user", :vcr do
    context "when there are some available and finished campaigns" do
      before do
        @user = create :user
        Campaign.all.each { |c| c.destroy }
        2.times { @available = create campaign_type, status: 'available' }
        2.times { @finished = create campaign_type, status: 'ended' }
        liked = create campaign_type, status: 'ended'
        Like.create(campaign: liked, user: @user)
      end

      it "returns first not-liked available campaign" do
        expect(Campaign.for_user(@user)).to eql Campaign.first
      end

      it "returns next not-liked available campaign" do
        Like.create(campaign: Campaign.first, user: @user)
        expect(Campaign.for_user(@user)).to eql @available
      end

      it "returns blank array when no campaign's available" do
        Like.create(campaign: Campaign.first, user: @user)
        Like.create(campaign: @available, user: @user)

        expect(Campaign.for_user(@user).blank?).to eql true
      end
    end
  end

  describe "#set_price", :vcr do
    context "it's an instagram campaign" do
      context "it's a money_getter campaign" do
        let(:campaign) { build campaign_type, payment_type: 'money_getter' }

        it "assigns the respective price to the campaign" do
          campaign.save
          expect(campaign.price.campaign_value).to eql Price.where(campaign_type: 'InstagramLikingCampaign', payment_type: 'money_getter').last.campaign_value
        end
      end
    end
  end

  describe "#liked_by?", :vcr do
    let(:user) { create :user }
    let(:campaign) { create campaign_type }

    context "when the campaign has already been liked by the user" do
      before do
        campaign.liking_users << user
        campaign.reload
      end

      it "should return true" do
        expect(campaign.liked_by? user).to eql true
      end
    end

    context "when the campaign is not liked by the user" do
      it "should return false" do
        expect(campaign.liked_by? user).to eql false
      end
    end
  end

end
