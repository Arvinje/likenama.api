require 'rails_helper'

RSpec.describe InstagramDetail, type: :model do

  it { should respond_to :short_code }
  it { should respond_to :description }
  it { should respond_to :phone }
  it { should respond_to :website }
  it { should respond_to :address }
  it { should respond_to :campaign_id }
  it { should respond_to :url }
  it { should respond_to :photo_url }

  describe "ActiveModel validations" do
    it { should validate_presence_of :short_code }
    it { should validate_presence_of :campaign }
  end

  describe "ActiveRecord associations" do
    it { should belong_to :campaign }
  end

  describe "#get_url", :vcr do
    before do
      @instagram_detail = build :instagram_detail, short_code: "42GewqWvc"
    end

    it "returns the full url of the page" do
      expect(@instagram_detail.get_url).to eql "http://instagram.com/p/42GewqWvc"
    end
  end

end
