require 'rails_helper'

RSpec.describe Purchase, type: :model do
  it { is_expected.to respond_to :user_id }
  it { is_expected.to respond_to :product_id }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :product_id }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to belong_to :product }
    it { is_expected.to belong_to :user }
  end
end
