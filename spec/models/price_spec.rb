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
end
