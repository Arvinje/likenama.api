require 'rails_helper'

RSpec.describe ProductType, type: :model do
  it { is_expected.to respond_to :name  }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :name }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to have_many(:products).dependent(:destroy) }
  end

end
