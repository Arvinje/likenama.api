require 'rails_helper'

RSpec.describe CampaignClass, type: :model do
  it { is_expected.to respond_to :campaign_type }
  it { is_expected.to respond_to :campaign_value }
  it { is_expected.to respond_to :coin_user_share }
  it { is_expected.to respond_to :like_user_share }
  it { is_expected.to respond_to :waiting }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :campaign_type }
    it { is_expected.to validate_presence_of :campaign_value }
    it { is_expected.to validate_presence_of :coin_user_share }
    it { is_expected.to validate_presence_of :like_user_share }
    it { is_expected.to validate_presence_of :waiting }

    it { is_expected.to validate_numericality_of(:campaign_value).only_integer }
    it { is_expected.to validate_numericality_of(:coin_user_share).only_integer }
    it { is_expected.to validate_numericality_of(:like_user_share).only_integer }
    it { is_expected.to validate_numericality_of(:waiting).only_integer }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to have_many :campaigns }
  end
end
