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

      it { is_expected.to respond_with 200 }
    end
  end

end
