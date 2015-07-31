require 'rails_helper'

RSpec.describe Campaign, type: :model do

  it { should respond_to :campaign_type }
  it { should respond_to :like_value }
  it { should respond_to :total_likes }
  it { should respond_to :owner_id }

  describe "ActiveModel validations" do
    it { should validate_presence_of :campaign_type }
    it { should validate_presence_of :like_value }
    it { should validate_presence_of :owner }

    it { should validate_numericality_of(:like_value).only_integer }
    it { should validate_numericality_of(:total_likes).only_integer }
  end

  describe "ActiveRecord associations" do
    it { should have_many(:likes).dependent :destroy }
    it { should have_many(:liking_users).through(:likes).source(:user) }
    it { should belong_to(:owner).class_name('User') }
    it { should have_one(:instagram_detail).dependent(:destroy) }
    it { should accept_nested_attributes_for :instagram_detail }
  end

  describe "#like" do
    let(:user) { create :user }
    let(:campaign) { create :campaign, owner: user }

    context "when a campaign is liked by a user" do
      it "should add the user to the liking_users" do
        campaign.like user
        expect(campaign.liking_users).to include user
      end

      it "should return true when a campaign gets liked successfully" do
        expect(campaign.like user).to eql true
      end

      it "should increase the total_likes by 1" do
        expect{ campaign.like user }.to change{ campaign.total_likes }.by(1)
        expect{ campaign.like user }.to_not change{ campaign.total_likes }
      end
    end
  end

  describe "#liked_by?" do
    let(:user) { create :user }
    let(:campaign) { create :campaign, owner: user }

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

end
