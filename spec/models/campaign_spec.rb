require 'rails_helper'

RSpec.describe Campaign, type: :model do

  it { should respond_to :type_id }
  it { should respond_to :like_value }
  it { should respond_to :total_likes }

  describe "ActiveModel validations" do
    it { should validate_presence_of :type_id }
    it { should validate_presence_of :like_value }

    it { should validate_numericality_of(:type_id).only_integer }
    it { should validate_numericality_of(:like_value).only_integer }
    it { should validate_numericality_of(:total_likes).only_integer }
  end

  describe "ActiveRecord associations" do
    it { should have_many(:likes).dependent :destroy }
    it { should have_many(:users).through(:likes) }
  end
end
