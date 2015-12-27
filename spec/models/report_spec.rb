require 'rails_helper'

RSpec.describe Report, type: :model do
  it { is_expected.to respond_to :checked }

  describe "ActiveModel validations" do
    it { is_expected.to validate_inclusion_of(:checked).in_array([true, false]) }
  end
end
