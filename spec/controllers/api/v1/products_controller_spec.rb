require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do

  describe "GET #index" do
    context "when there are some products available" do
      let(:user) { create :user }
      before do
        Product.all.each { |p| p.destroy }    # cleans the products and product_details tables
        @product = create :product_with_details
        3.times { create :product_with_details }
        create :product, available: false
        api_authorization_header user.auth_token
        get :index
      end

      it "renders an array of products" do
        products_response = json_response[:products]
        expect(products_response.size).to eql 4
      end

      it "renders all available products" do
        products_response = json_response[:products]
        expect(products_response.first[:title]).to eql @product.title
      end

      it { is_expected.to respond_with :ok }
    end

    context "when there's no product available" do
      let(:user) { create :user }
      before do
        Product.all.each { |p| p.destroy }    # cleans the products and product_details tables
        3.times { create :product, available: false }
        api_authorization_header user.auth_token
        get :index
      end

      it "should render an errors json" do
        campaign_response = json_response
        expect(campaign_response).to have_key :errors
      end

      it "should render the json errors on why the user could not be created" do
        campaign_response = json_response
        expect(campaign_response[:errors][:base]).to include "the requested record(s) cannot be found"
      end

      it { should respond_with :not_found }
    end
  end

end
