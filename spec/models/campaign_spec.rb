require 'rails_helper'

RSpec.describe Campaign, type: :model do

  before do
    allow(KeyValue).to receive(:instagram_money_getter_value).and_return(2)
    allow(KeyValue).to receive(:instagram_like_getter_value).and_return(1)
  end

  it { should respond_to :campaign_type }
  it { should respond_to :payment_type }
  it { should respond_to :like_value }
  it { should respond_to :total_likes }
  it { should respond_to :owner_id }

  describe "ActiveModel validations" do
    it { should validate_presence_of :campaign_type }
    it { should validate_presence_of :payment_type }
    it { should validate_presence_of :total_likes }
    it { should validate_presence_of :owner }

    it { should validate_numericality_of(:total_likes).only_integer }

    describe "#must_have_one_association" do
      context "when no detail got specified" do
        before do
          owner = create :user
          @campaign = Campaign.new(attributes_for(:campaign))
          @campaign.owner = create :user
          @campaign.save
        end
        subject { @campaign }

        it "should raise an error" do
          expect(@campaign.errors.full_messages).to include "must have some details"
        end

        it { should_not be_valid }
      end
    end
  end

  describe "ActiveRecord associations" do
    it { should have_many(:likes).dependent :destroy }
    it { should have_many(:liking_users).through(:likes).source(:user) }
    it { should belong_to(:owner).class_name('User') }
    it { should have_one(:instagram_detail).dependent(:destroy) }
    it { should accept_nested_attributes_for(:instagram_detail).update_only(true) }
  end

  describe "Callbacks" do
    let(:campaign) { create :campaign }

    it { expect(campaign).to callback(:set_like_value).before(:save) }
  end

  describe "#instagram_only" do
    context "when the campaign_type is equal to 'instagram'" do
      let(:campaign) { build :campaign, campaign_type: 'instagram' }
      it "should return false" do
        expect(campaign.instagram_only).to eql false
      end
    end

    context "when the campaign_type is equal to something else" do
      let(:campaign) { build :campaign, campaign_type: 'web' }
      it "should return true" do
        expect(campaign.instagram_only).to eql true
      end
    end
  end

  describe "#set_like_value" do
    context "it's an instagram campaign" do
      context "it's a money_getter campaign" do
        let(:campaign) { build :campaign, campaign_type: "instagram", payment_type: "money_getter" }
        before do
          campaign.set_like_value
        end
        it "should assign the respective like_value to the campaign" do
          expect(campaign.like_value).to eql KeyValue.instagram_money_getter_value
        end
      end

      context "it's a like_getter campaign" do
        let(:campaign) { build :campaign, campaign_type: "instagram", payment_type: "like_getter" }
        before do
          campaign.set_like_value
        end
        it "should assign the respective like_value to the campaign" do
          expect(campaign.like_value).to eql KeyValue.instagram_like_getter_value
        end
      end
    end
  end

  describe "#like" do
    context "when a campaign is liked by a user" do
    let(:user) { create :user }
    let(:campaign) { create :campaign }

      it "should add the user to the liking_users" do
        campaign.like user
        expect(campaign.liking_users).to include user
      end

      it "should return true when a campaign gets liked successfully" do
        campaign.like user
        expect(campaign.like user).to eql true
      end

      it "should increase the total_likes by 1" do
        expect{ campaign.like user }.to change{ campaign.total_likes }.by 1
        expect{ campaign.like user }.to_not change{ campaign.total_likes }
        expect(campaign.total_likes).to eql 1
      end
    end

    context "when it's a like_getter campaign" do
      let(:user) { create :user }
      let(:campaign) { create :campaign, payment_type: "like_getter" }

      it "should increase the user's like credit by the like_value" do
        expect{ campaign.like user }.to change{ user.like_credit }.by campaign.like_value
        expect{ campaign.like user }.to_not change{ user.like_credit }
      end
    end

    context "when it's a money_getter campaign" do
      let(:user) { create :user }
      let(:campaign) { create :campaign, payment_type: "money_getter"}

      it "should increase the user's coin credit by the like_value" do
        expect{ campaign.like user }.to change{ user.coin_credit }.by campaign.like_value
        expect{ campaign.like user }.to_not change{ user.coin_credit }
      end
    end
  end

  describe "#liked_by?" do
    let(:user) { create :user }
    let(:campaign) { create :campaign }

    context "when the campaign has already been liked by the user" do
      before do
        campaign.like user
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

  describe "#check_like!" do

    context "when it's a instagram campaign" do
      context "when user's access token is invalid" do
        before do
          @user = create :user
          @campaign = create :campaign
          create :instagram_detail, campaign: @campaign, short_code: Rails.application.secrets.liked_instagram_shortcode
        end

        it "should return false" do
          expect(@campaign.check_like!(@user, instagram_access_token: "***REMOVED***")).to eql false
        end
      end

      context "when user has liked the instagram photo" do
        before do
          @user = create :user
          @campaign = create :campaign
          create :instagram_detail, campaign: @campaign, short_code: Rails.application.secrets.liked_instagram_shortcode
        end

        it "should return true" do
          expect(@campaign.check_like!(@user, instagram_access_token: Rails.application.secrets.access_token_no1)).to eql true
        end
      end

      context "when user has not liked the instagram photo" do
        before do
          @user = create :user
          @campaign = create :campaign
          create :instagram_detail, campaign: @campaign, short_code: Rails.application.secrets.not_liked_instagram_shortcode
        end

        it "should return false" do
          expect(@campaign.check_like!(@user, instagram_access_token: Rails.application.secrets.access_token_no1)).to eql false
        end
      end
    end
  end

end
