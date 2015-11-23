require 'rails_helper'

RSpec.describe Api::V1::Products::PurchasesController, type: :controller do
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

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it "should render the json errors on why the user could not be created" do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include "مورد درخواست‌شده یافت نشد"
      end

      it { is_expected.to respond_with :not_found }
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

      it { is_expected.to respond_with :created }
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
        expect(product_response[:errors][:coin_credit]).to include "اعتبار شما برای خرید این محصول کافی نیست"
      end

      it { is_expected.to respond_with :unprocessable_entity }
    end
  end
end
