require 'rails_helper'

RSpec.describe Like, type: :model do
  describe "ActiveModel validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :campaign }
  end

  describe "ActiveRecord associations" do
    it { should belong_to :user }
    it { should belong_to :campaign }
  end
end
