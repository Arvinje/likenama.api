require 'rails_helper'

RSpec.describe Campaign, type: :model do

  it { should respond_to :campaign_type }
  it { should respond_to :payment_type }
  it { should respond_to :total_likes }
  it { should respond_to :budget }
  it { should respond_to :available }
  it { should respond_to :verified }
  it { should respond_to :owner_id }
  it { should respond_to :price_id }
  it { should respond_to :waiting_id }

  describe "ActiveModel validations" do
    it { should validate_presence_of :campaign_type }
    it { should validate_presence_of :payment_type }
    it { should validate_presence_of :budget }
    it { should validate_presence_of :owner }

    it { should validate_numericality_of(:budget).only_integer }

    describe "#must_have_one_association", :vcr do
      context "when no detail got specified" do
        before do
          @campaign = Campaign.new(attributes_for(:campaign))
          @campaign.owner = create :user
          @campaign.save
        end
        subject { @campaign }

        it "should raise an error" do
          expect(@campaign.errors.full_messages).to include "اطلاعات واردشده برای ساخت کمپین کافی نیست"
        end

        it { should_not be_valid }
      end
    end
  end

  describe "ActiveRecord associations" do
    it { is_expected.to have_many(:likes).dependent :destroy }
    it { is_expected.to have_many(:liking_users).through(:likes).source(:user) }
    it { is_expected.to belong_to(:owner).class_name('User') }
    it { is_expected.to have_one(:instagram_detail).dependent(:destroy) }
    it { is_expected.to accept_nested_attributes_for(:instagram_detail).update_only(true) }
    it { is_expected.to belong_to(:price) }
    it { is_expected.to belong_to(:waiting) }
    it { is_expected.to have_many(:reports).dependent :destroy }
    it { is_expected.to have_many(:reporters).through(:reports).source(:user) }
  end

  describe "Callbacks", :vcr do
    let(:campaign) { create :campaign }

    it { expect(campaign).to callback(:set_price).before(:save) }
    it { expect(campaign).to callback(:set_waiting).before(:save) }
  end

  describe "#detail" do
    context "when it's an instagram campaign" do
      let(:campaign) { create :campaign, campaign_type: 'instagram' }

      it "returns the respective detail" do
        expect(campaign.detail).to eql campaign.instagram_detail
      end
    end
  end

  describe "#verify!", :vcr do
    let(:campaign) { create :campaign, available: nil, verified: nil }

    before do
      campaign.verify!
      campaign.reload
    end

    it "sets available and verified true" do
      expect(campaign.verified).to eql true
      expect(campaign.available).to eql true
    end
  end

  describe "#reject!", :vcr do
    context "on each type of campaign" do
      let(:campaign) { create :campaign, available: nil, verified: nil }

      before do
        campaign.reject!
        campaign.reload
      end

      it "sets available nil and verified false" do
        expect(campaign.verified).to eql false
        expect(campaign.available).to eql nil
      end
    end
    context "when it's a like_getter campaign" do
      before do
        @owner = create :user, like_credit: 400
        @campaign = create :campaign, available: nil, verified: nil, payment_type: "like_getter", budget: 100, owner: @owner
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
        @campaign = create :campaign, available: nil, verified: nil, payment_type: "money_getter", budget: 100, owner: @owner
        @campaign.reject!
        @campaign.reload
      end

      it "returns the budget back to the owner's account" do
        expect(@campaign.owner.coin_credit).to eql 400
      end
    end
  end

  describe "#status", :vcr do
    context "the verification is pending" do
      let(:campaign) { build :campaign, verified: nil, available: nil }

      it "returns respective status" do
        expect(campaign.status).to eql "درحال بررسی"
      end
    end
    context "the campaign's over" do
      let(:campaign) { build :campaign, verified: true, available: false }

      it "returns respective status" do
        expect(campaign.status).to eql "به‌پایان رسیده"
      end
    end
    context "the campaign's active" do
      let(:campaign) { build :campaign, verified: true, available: true }

      it "returns respective status" do
        expect(campaign.status).to eql "درحال نمایش"
      end
    end
    context "the campaign's not active" do
      let(:campaign) { build :campaign, verified: true, available: nil }

      it "returns respective status" do
        expect(campaign.status).to eql "نمایش داده‌نشده"
      end
    end
    context "the campaign's rejected" do
      let(:campaign) { build :campaign, verified: false, available: nil }

      it "returns respective status" do
        expect(campaign.status).to eql "رد شده"
      end
    end
  end

  describe "#detail", :vcr do
    context "it's an Instagram campaign" do
      let(:instagram_detail) { create :instagram_detail }
      it "returns respective detail" do
        expect(instagram_detail.campaign.detail).to eql instagram_detail
      end
    end
  end

  describe "#set_waiting", :vcr do
    context "it's an instagram campaign" do
      context "it's a money_getter campaign" do
        let(:campaign) { build :campaign, campaign_type: 'instagram', payment_type: 'money_getter' }
        it "assigns the respective waiting to the campaign" do
          campaign.save
          expect(campaign.waiting.period).to eql Waiting.where(campaign_type: 'instagram', payment_type: 'money_getter').last.period
        end
      end
    end
  end

  describe "#for_user", :vcr do
    context "when there are some available and finished campaigns" do
      before do
        @user = create :user
        Campaign.all.each { |c| c.destroy }
        2.times { @available = create :campaign, available: true }
        2.times { @finished = create :campaign, available: false }
        liked = create :campaign, available: true
        CampaignLiking.new(liked, @user, INSTAGRAM_ACCESS_TOKEN).like!
      end

      it "returns first not-liked available campaign" do
        expect(Campaign.for_user(@user)).to eql Campaign.first
      end

      it "returns next not-liked available campaign" do
        CampaignLiking.new(Campaign.first, @user, INSTAGRAM_ACCESS_TOKEN).like!
        expect(Campaign.for_user(@user)).to eql @available
      end

      it "returns blank array when no campaign's available" do
        CampaignLiking.new(Campaign.first, @user, INSTAGRAM_ACCESS_TOKEN).like!
        CampaignLiking.new(@available, @user, INSTAGRAM_ACCESS_TOKEN).like!
        expect(Campaign.for_user(@user).blank?).to eql true
      end
    end
  end

  describe "#set_price", :vcr do
    context "it's an instagram campaign" do
      context "it's a money_getter campaign" do
        let(:campaign) { build :campaign, campaign_type: 'instagram', payment_type: 'money_getter' }
        it "assigns the respective price to the campaign" do
          campaign.save
          expect(campaign.price.campaign_value).to eql Price.where(campaign_type: 'instagram', payment_type: 'money_getter').last.campaign_value
        end
      end
    end
  end

  describe "#instagram_only", :vcr do
    context "when the campaign_type is equal to 'instagram'" do
      let(:campaign) { build :campaign, campaign_type: 'instagram' }
      it "should return false" do
        expect(campaign.instagram_only).to eql false
      end
    end

    context "when the campaign_type is equal to something else" do
      let(:campaign) { Campaign.new(campaign_type: 'web') }

      it "should return true" do
        expect(campaign.instagram_only).to eql true
      end
    end
  end

  describe "#liked_by?", :vcr do
    let(:user) { create :user }
    let(:campaign) { create :campaign }

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
