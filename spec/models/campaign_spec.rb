require 'rails_helper'

RSpec.describe Campaign, type: :model do

  it { should respond_to :type }
  it { should respond_to :like_value }
  it { should respond_to :total_likes }

  describe "ActiveModel validations" do
    it { should validate_presence_of :type }
    it { should validate_presence_of :like_value }

    it { should validate_numericality_of(:type).only_integer }
    it { should validate_numericality_of(:like_value).only_integer }
    it { should validate_numericality_of(:total_likes).only_integer }
  end

  describe "ActiveRecord associations" do
    it { should have_many(:likes).dependent :destroy }
    it { should have_many(:liking_users).through(:likes).source(:user) }
  end

  describe "#like" do
    let(:user) { create :user }
    let(:campaign) { create :campaign }

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
      end
    end
  end
end
