require 'rails_helper'

RSpec.describe Message, type: :model do
  before { @message = build :message }
  subject { @message }

  it { is_expected.to respond_to :user }
  it { is_expected.to respond_to :content }
  it { is_expected.to respond_to :read }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :content }
    it { is_expected.to validate_presence_of :user }

    it { is_expected.to validate_length_of(:content).is_at_most(500) }

    it { is_expected.to allow_value('sample@example.com').for :email }
    it { is_expected.not_to allow_value('sample@examplecom').for :email }

    it { is_expected.to be_valid }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to belong_to :user }
  end
end
