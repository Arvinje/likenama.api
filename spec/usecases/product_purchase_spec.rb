require 'rails_helper'

RSpec.describe ProductPurchase do

  describe "#buy" do
    context "when user purchases the product successfully" do
      let(:user) { create :user, coin_credit: 300 }
      let(:product) { create :product_with_details, price: 100 }
      let(:purchase) { ProductPurchase.new(user,product) }

      it "returns true" do
        expect(purchase.buy).to be true
      end

      it "decreases the user's coin_credit by the product's price" do
        expect{ purchase.buy }.to change{ user.coin_credit }.by(-100)
      end

      it "adds the purchased detail to the list of user's purchased details" do
        purchase.buy
        expect(user.purchased_details.include?(purchase.purchased_detail)).to be true
      end

      it "marks the purchased_detail as not available" do
        purchase.buy
        expect(purchase.purchased_detail.available).to be false
      end

      it "returns a user with no errors" do
        purchase.buy
        expect(purchase.user.errors.blank?).to be true
      end
    end

    context "when user doesn't have enough credit" do
      let(:user) { create :user, coin_credit: 50 }
      let(:product) { create :product_with_details, price: 100 }
      let(:purchase) { ProductPurchase.new(user,product) }

      it "returns false" do
        expect(purchase.buy).to be false
      end

      it "returns a user with respective errors" do
        purchase.buy
        expect(purchase.user.errors[:coin_credit]).to include I18n.t 'errors.messages.not_enough_credit'
      end
    end
  end

end
