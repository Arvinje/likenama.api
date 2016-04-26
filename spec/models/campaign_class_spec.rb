require 'rails_helper'

RSpec.describe CampaignClass, type: :model do
  it { is_expected.to respond_to :campaign_type }
  it { is_expected.to respond_to :campaign_value }
  it { is_expected.to respond_to :coin_user_share }
  it { is_expected.to respond_to :like_user_share }
  it { is_expected.to respond_to :waiting }

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of :campaign_type }
    it { is_expected.to validate_presence_of :campaign_value }
    it { is_expected.to validate_presence_of :coin_user_share }
    it { is_expected.to validate_presence_of :like_user_share }
    it { is_expected.to validate_presence_of :waiting }

    it { is_expected.to validate_numericality_of(:campaign_value).only_integer }
    it { is_expected.to validate_numericality_of(:coin_user_share).only_integer }
    it { is_expected.to validate_numericality_of(:like_user_share).only_integer }
    it { is_expected.to validate_numericality_of(:waiting).only_integer }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to have_many :campaigns }
  end

  describe '#deactivate_previous_class' do
    context "when there's a previous class with the same specs as the current one" do
      before do
        CampaignClass.all.each { |c| c.destroy }
        @klass = create :instagram_liking_coin_with_waiting_class
        create :instagram_liking_coin_with_waiting_class
      end

      it "deactivates previous record" do
        @klass.reload
        expect(@klass.inactive?).to be true
      end
    end

    context "when there's not a previous class with the same specs" do
      before do
        CampaignClass.all.each { |c| c.destroy }
      end

      it "doesn't deactivate any previous records" do
        @klass = create :instagram_liking_coin_class, waiting: 0
        create :instagram_liking_coin_with_waiting_class, waiting: 5
        @klass.reload
        expect(@klass.active?).to be true
      end
    end
  end

end
