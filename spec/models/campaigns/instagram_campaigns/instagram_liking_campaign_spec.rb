require 'rails_helper'

RSpec.describe InstagramLikingCampaign, type: :model do
  it_behaves_like "a campaign", :instagram_liking_campaign

  describe "ActiveModel validations" do
    subject { build :instagram_liking_campaign }

    it { is_expected.to allow_value('makandracards.com/makandra/643-testing-validates_format_of-with-shoulda-matchers').for(:website) }
    it { is_expected.not_to allow_value("").for(:website) }
    it { is_expected.not_to allow_value("http://makandracards/.c").for(:website) }

    it { is_expected.to validate_length_of(:description).is_at_most(500) }
    it { is_expected.to validate_length_of(:phone).is_at_least(10).is_at_most(12) }
    it { is_expected.to validate_length_of(:website).is_at_most(150) }
    it { is_expected.to validate_length_of(:address).is_at_most(200) }
  end

end
