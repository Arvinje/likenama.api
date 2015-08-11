require 'rails_helper'

RSpec.describe InstagramDetail, type: :model do

  before do
    allow(KeyValue).to receive(:instagram_money_getter_value).and_return(2)
    allow(KeyValue).to receive(:instagram_like_getter_value).and_return(1)
  end

  it { should respond_to :short_code }
  it { should respond_to :description }
  it { should respond_to :phone }
  it { should respond_to :website }
  it { should respond_to :address }
  it { should respond_to :waiting }
  it { should respond_to :campaign_id }
  it { should respond_to :photo_url }

  describe "ActiveModel validations" do
    it { should validate_presence_of :short_code }
    it { should validate_presence_of :campaign }
    it { should validate_presence_of :photo_url }

    it { should validate_numericality_of(:waiting).only_integer }
  end

  describe "ActiveRecord associations" do
    it { should belong_to :campaign }
  end

  describe "#must_have_valid_short_code" do
    context "when it's a valid shortcode" do
      let(:instagram_detail) { build :instagram_detail }
      before do
        @valid_detail = instagram_detail
        @valid_detail.save
      end

      it "should raise no exceptions" do
        expect(@valid_detail).to be_valid
      end
    end

    context "when it's an invalid shortcode" do
      let(:instagram_detail) { build :instagram_detail, short_code: "435gsfgEF445352" }
      before do
        @failed_detail = instagram_detail
        @failed_detail.save
      end

      it "should raise a validation failure" do
        expect(@failed_detail).to_not be_valid
      end

      it "should give the reason on the error" do
        expect(@failed_detail.errors.messages[:short_code]).to include "invalid shortcode"
      end
    end
  end

  describe "#get_instagram_photo_url" do
    context "when it's a valid shortcode" do
      let(:instagram_detail) { build :instagram_detail }
      it "should assign the photo_url for the requested shortcode" do
        instagram_detail.get_instagram_photo_url
        expect(instagram_detail.photo_url).to eql "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/11420731_1451437075163975_977025466_n.jpg"
      end

      it "should return true" do
        expect(instagram_detail.get_instagram_photo_url).to eql true
      end
    end

    context "when it's an invalid shortcode" do
      let(:instagram_detail) { build :instagram_detail, short_code: "435gsfgEF445352" }
      it "should return false" do
        expect(instagram_detail.get_instagram_photo_url).to eql false
      end
    end
  end

end
