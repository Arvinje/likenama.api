require 'rails_helper'

RSpec.describe Gift, type: :model do
  before { @message = build :gift }
  subject { @message }

  it { is_expected.to respond_to :user }
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :coin_credit }
  it { is_expected.to respond_to :like_credit }
  it { is_expected.to respond_to :duration }
  it { is_expected.to respond_to :status }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :duration }

    it { is_expected.to validate_numericality_of(:coin_credit).is_greater_than_or_equal_to(0).only_integer }
    it { is_expected.to validate_numericality_of(:like_credit).is_greater_than_or_equal_to(0).only_integer }

    it { is_expected.to allow_value('example@domain.com').for :email }
    it { is_expected.not_to allow_value('@exampledomain.com').for :email }

    it { is_expected.to be_valid }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to belong_to(:user).with_foreign_key('email').with_primary_key('email') }
  end
end
