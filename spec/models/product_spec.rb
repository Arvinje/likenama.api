require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to respond_to :title }
  it { is_expected.to respond_to :description }
  it { is_expected.to respond_to :price }
  it { is_expected.to respond_to :available }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :price }

    it { is_expected.to validate_numericality_of(:price).only_integer }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to have_many(:details).class_name('ProductDetail') }
    it { is_expected.to accept_nested_attributes_for :details }
  end
end
