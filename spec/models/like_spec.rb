require 'rails_helper'

RSpec.describe Like, type: :model do
  it { is_expected.to respond_to :user_id }
  it { is_expected.to respond_to :campaign_id }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :campaign }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :campaign }
  end
end
