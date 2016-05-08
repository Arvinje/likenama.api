require 'rails_helper'

RSpec.describe Api::V1::Bundles::PurchasesController, type: :controller do

  describe "POST #create" do
    context "when bazaar_sku is wrong" do
      let(:user) { create :user }
      before do
        3.times { create :bundle }
        @requested_bundle = create :bundle
        bad_sku = @requested_bundle.bazaar_sku
        @requested_bundle.destroy
        api_authorization_header user.auth_token
        post :create, { bazaar_sku: bad_sku, bundle: { purchase_token: 'SnIN1yvZqWkcB-QwQ' } }
      end

      it "should render an errors json" do
        expect(json_response).to have_key :errors
      end

      it "should render some json errors" do
        expect(json_response[:errors][:base]).to include I18n.t 'errors.messages.not_found'
      end

      it { is_expected.to respond_with :not_found }
    end

    context "when user purchases the bundle successfully" do
      let(:user) { create :user }
      before do
        3.times { create :bundle }
        @requested_bundle = create :bundle, bazaar_sku: 'buy_anti_hack_25_off'
        api_authorization_header user.auth_token
        post :create, { bazaar_sku: @requested_bundle.bazaar_sku, bundle: { purchase_token: 'SnIN1yvZqWkcB-QwQ' } }
      end

      it { is_expected.to respond_with :created }
    end

    context "when the purchase ia not valid" do
      let(:user) { create :user }
      before do
        3.times { create :bundle }
        @requested_bundle = create :bundle, bazaar_sku: 'buy_anti_hack_25_off'
        api_authorization_header user.auth_token
        post :create, { bazaar_sku: @requested_bundle.bazaar_sku, bundle: { purchase_token: 'SnIN1ybadtWkCB-QwQ' } }
      end

      it "renders an errors json" do
        expect(json_response[:errors][:base]).to include I18n.t 'errors.messages.payment_not_valid'
      end

      it { is_expected.to respond_with :unprocessable_entity }
    end

  end

end
