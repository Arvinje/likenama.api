require 'rails_helper'

RSpec.describe ProductType, type: :model do
  it { is_expected.to respond_to :name  }

  describe "ActiveModel validations" do
    subject { create :product_type }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to have_many(:products).dependent(:destroy) }
  end

end
