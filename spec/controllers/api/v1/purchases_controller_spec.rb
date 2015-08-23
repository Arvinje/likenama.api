require 'rails_helper'

RSpec.describe Api::V1::PurchasesController, type: :controller do
  describe "POST #create" do
    context "when product_id is wrong" do
      let(:user) { create :user }
      before do
        3.times { create :product_with_details }
        @requested_product = create :product_with_details
        bad_id = @requested_product.id
        @requested_product.destroy
        api_authorization_header user.auth_token
        post :create, { product_id: bad_id }
      end

      it "renders json errors" do
        product_response = json_response
        expect(product_response[:errors][:base]).to include "wrong product_id"
      end

      it { is_expected.to respond_with 422 }
    end

    context "when user purchases the product successfully" do
      let(:user) { create :user }
      before do
        3.times { create :product_with_details }
        @requested_product = create :product_with_details
        api_authorization_header user.auth_token
        post :create, { product_id: @requested_product.id }
      end

      it "renders json for the product with one of the details" do
        product_response = json_response
        expect(product_response[:details][:product][:title]).to eql @requested_product.title
        expect(product_response[:details][:code]).to eql @requested_product.details.first.code
      end
    end

    context "when user doesn't have enough credit" do
      let(:user) { create :user, coin_credit: 10 }
      before do
        3.times { create :product_with_details }
        @requested_product = create :product_with_details, price: 1000
        api_authorization_header user.auth_token
        post :create, { product_id: @requested_product.id }
      end

      it "renders respective error" do
        product_response = json_response
        expect(product_response[:errors][:coin_credit]).to include "doesn't have enough credit"
      end

      it { is_expected.to respond_with 422 }
    end
  end
end
