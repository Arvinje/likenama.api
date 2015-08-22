require 'rails_helper'

RSpec.describe ProductDetail, type: :model do
  it { is_expected.to respond_to :code }
  it { is_expected.to respond_to :description }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :description }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to belong_to :product }
  end
end
