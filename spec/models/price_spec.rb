require 'rails_helper'

RSpec.describe Price, type: :model do
  it { is_expected.to respond_to :campaign_type }
  it { is_expected.to respond_to :payment_type }
  it { is_expected.to respond_to :campaign_value }
  it { is_expected.to respond_to :users_share }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :campaign_type }
    it { is_expected.to validate_presence_of :payment_type }
    it { is_expected.to validate_presence_of :campaign_value }
    it { is_expected.to validate_presence_of :users_share }

    it { is_expected.to validate_numericality_of(:campaign_value).only_integer }
    it { is_expected.to validate_numericality_of(:users_share).only_integer }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to have_many :campaigns }
  end

  describe "#instagram_like_getter" do
    let(:price) { create :price, campaign_type: 'instagram', payment_type: 'like_getter' }

    it "returns the last registered price for instagram like_getter campaigns" do
      price
      expect(Price.instagram_like_getter.campaign_value).to eql price.campaign_value
    end
  end

  describe "#instagram_money_getter" do
    let(:price) { create :price, campaign_type: 'instagram', payment_type: 'money_getter' }

    it "returns the last registered price for instagram like_getter campaigns" do
      price
      expect(Price.instagram_money_getter.campaign_value).to eql price.campaign_value
    end
  end
end
