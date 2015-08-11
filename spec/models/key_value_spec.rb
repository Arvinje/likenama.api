require 'rails_helper'

RSpec.describe KeyValue, type: :model do

  it { should respond_to(:key) }
  it { should respond_to(:value) }

  describe "ActiveModel validations" do
    it { should validate_presence_of :key }
    it { should validate_presence_of :value }

    it { should validate_numericality_of :value }
  end

  describe ".instagram_money_getter_value" do
    before do
      @existing = create :key_value, key: "InstagramMoneyGetterLikeValue", value: 10
    end

    it "should return the requested value" do
      expect(KeyValue.instagram_money_getter_value).to eql @existing.value
    end
  end

  describe ".instagram_like_getter_value" do
    before do
      @existing = create :key_value, key: "InstagramLikeGetterLikeValue", value: 20
    end

    it "should return the requested value" do
      expect(KeyValue.instagram_like_getter_value).to eql @existing.value
    end
  end

end
