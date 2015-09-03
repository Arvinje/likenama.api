require 'rails_helper'

RSpec.describe Waiting, type: :model do
  it { is_expected.to respond_to :campaign_type }
  it { is_expected.to respond_to :payment_type }
  it { is_expected.to respond_to :period }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :campaign_type }
    it { is_expected.to validate_presence_of :payment_type }
    it { is_expected.to validate_presence_of :period }

    it { is_expected.to validate_numericality_of(:period).only_integer }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to have_many :campaigns }
  end

end