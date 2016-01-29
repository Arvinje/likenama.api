require 'rails_helper'

RSpec.describe CampaignCreation do

  describe '#save', :vcr do
    let(:user) { create :user }
    let(:params) { attributes_for(:campaign).merge({detail: attributes_for(:instagram_detail)}) }
    let(:creation) { CampaignCreation.new(params,user) }
    before do
      allow(OperatorRegistry).to receive(:detail_for).with(params[:campaign_type]).and_return InstagramDetail
    end

    context "when the both models are valid" do

      it "returns true" do
        expect(creation.save).to be true
      end

      it "doesn't have any errors hash on campaign instance" do
        creation.save
        expect(creation.campaign.errors).to be_empty
      end
    end

    context "when there are some errors on the parent instance" do
      before do
        params[:budget] = 0
      end

      it "returns true" do
        expect(creation.save).to be false
      end

      it "has some errors on campaign instance" do
        creation.save
        expect(creation.campaign.errors[:budget]).to include I18n.t 'errors.messages.greater_than', count: 0
      end
    end

    context "when there are some errors on the detail instance" do
      before do
        params[:detail][:url] = "http://instagram.com/p/59gQ0Gi0UZ"
      end

      it "returns true" do
        expect(creation.save).to be false
      end

      it "has some errors on detail instance" do
        creation.save
        expect(creation.campaign.errors[:'detail.url']).to include I18n.t 'errors.messages.wrong_instagram_url'
      end
    end
  end

end
