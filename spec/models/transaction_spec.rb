require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { is_expected.to respond_to :id_get }
  it { is_expected.to respond_to :trans_id }

  describe "ActiveModel validations" do
    
  end

  describe "ActiveRecord associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :bundle }
  end
end
