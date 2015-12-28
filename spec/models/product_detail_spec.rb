require 'rails_helper'

RSpec.describe ProductDetail, type: :model do
  it { is_expected.to respond_to :code }

  describe "ActiveModel validations" do
    let(:product) { create :product }
    subject { build :product_detail, product: product }
    
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to belong_to :product }
    it { is_expected.to belong_to :user }
  end

  describe ".available" do
    before do
      @product = create :product_with_details
      @not_available = @product.details.last
      @not_available.available = false
      @not_available.save
      @not_available.reload
      @product.reload
    end

    it "returns the available product details" do
      expect(ProductDetail.available).to include @product.details.first
      expect(ProductDetail.available).not_to include @not_available
    end
  end
end
