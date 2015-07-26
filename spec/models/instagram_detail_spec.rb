require 'rails_helper'

RSpec.describe InstagramDetail, type: :model do

  it { should respond_to :short_code }
  it { should respond_to :description }
  it { should respond_to :phone }
  it { should respond_to :website }
  it { should respond_to :address }
  it { should respond_to :waiting }
  it { should respond_to :campaign_id }

  describe "ActiveModel validations" do
    it { should validate_presence_of :short_code }
    it { should validate_presence_of :campaign }

    it { should validate_numericality_of(:waiting).only_integer }
  end

  describe "ActiveRecord associations" do
    it { should belong_to :campaign }
  end
end
