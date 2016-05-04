require 'rails_helper'

RSpec.describe BundlePurchase, type: :model do
  it { is_expected.to respond_to :user }
  it { is_expected.to respond_to :bundle }
  it { is_expected.to respond_to :bazaar_purhcase_token }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :bundle }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :bundle }
  end

end
