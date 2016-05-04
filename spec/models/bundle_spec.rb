require 'rails_helper'

RSpec.describe Bundle, type: :model do
  it { is_expected.to respond_to :price }
  it { is_expected.to respond_to :coins }
  it { is_expected.to respond_to :free_coins }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :price }
    it { is_expected.to validate_presence_of :coins }

    it { is_expected.to validate_numericality_of(:price).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:coins).only_integer.is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:free_coins).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to have_many :bundle_purchases }
    it { is_expected.to have_many(:buyers).through(:bundle_purchases).source(:user) }
  end

end
