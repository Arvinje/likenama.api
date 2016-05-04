require 'rails_helper'

RSpec.describe PurchaseBundle do

  describe "#buy" do
    let(:user) { create :user }
    let(:bundle) { create :bundle }
    let(:purchase) { PurchaseBundle.new(user, bundle, "S0mePurcha5eT0k3n") }

    context "when the purchase is available in the db" do
      before do
        create :bundle_purchase, user: user, bundle: bundle, bazaar_purhcase_token: "S0mePurcha5eT0k3n"
      end

      it "returns true" do
        expect(purchase.buy).to be true
      end
    end

    context 'when its a new and valid purchase' do
      before do
        allow(purchase.instance_variable_get :@bazaar).to receive(:verify)
        allow(purchase.instance_variable_get :@bazaar).to receive(:purchased?).and_return true
      end

      it "returns true" do
        expect(purchase.buy).to be true
      end

      it "doesn't have any errors" do
        expect(purchase.user.errors[:base]).to be_empty
      end

      it "creates a bundle_purchase record" do
        purchase.buy
        expect(BundlePurchase.exists?(user: user, bundle: bundle, bazaar_purhcase_token: "S0mePurcha5eT0k3n")).to be true
      end

      it "adds the purchased coins to user's account" do
        expect{ purchase.buy }.to change{ user.coin_credit }.by(bundle.coins + bundle.free_coins)
      end
    end

    context 'when its a refunded purchase' do
      before do
        allow(purchase.instance_variable_get :@bazaar).to receive(:verify)
        allow(purchase.instance_variable_get :@bazaar).to receive(:purchased?).and_return false
      end

      it "returns false" do
        expect(purchase.buy).to be false
      end

      it "has respective errors" do
        purchase.buy
        expect(purchase.user.errors[:base]).to include I18n.t 'errors.messages.payment_not_valid'
      end
    end

    context 'when its not a valid purchase' do
      before do
        allow(purchase.instance_variable_get :@bazaar).to receive(:verify).and_raise InvalidVerification
      end

      it "returns false" do
        expect(purchase.buy).to be false
      end

      it "has respective errors" do
        purchase.buy
        expect(purchase.user.errors[:base]).to include I18n.t 'errors.messages.payment_not_valid'
      end
    end

    context "when there's an authentication problem" do
      before do
        allow(purchase.instance_variable_get :@bazaar).to receive(:verify).and_raise InvalidAuthentication
      end

      it "returns false" do
        expect(purchase.buy).to be false
      end

      it "has respective errors" do
        purchase.buy
        expect(purchase.user.errors[:base]).to include I18n.t 'errors.messages.payment_problem'
      end
    end

  end

end
