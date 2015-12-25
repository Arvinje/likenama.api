require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to respond_to :title }
  it { is_expected.to respond_to :description }
  it { is_expected.to respond_to :price }
  it { is_expected.to respond_to :available }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :price }
    it { is_expected.to validate_presence_of :product_type }

    it { is_expected.to validate_numericality_of(:price).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to belong_to(:product_type) }
    it { is_expected.to have_many(:details).class_name('ProductDetail').dependent(:destroy) }
    it { is_expected.to have_many(:buyers).through(:details).source(:user) }
    it { is_expected.to accept_nested_attributes_for :details }
  end
end
