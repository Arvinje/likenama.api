require 'rails_helper'

RSpec.describe Api::V1::BundlesController, type: :controller do

  describe "GET #index" do
    context "when there are some active bundles" do
      let(:user) { create :user }
      before do
        Bundle.all.each { |b| b.destroy }    # cleans the bundles table
        @bundle = create :bundle
        3.times { create :bundle }
        create :bundle, status: false
        api_authorization_header user.auth_token
        get :index
      end

      it "renders an array of bundles" do
        bundles_response = json_response[:bundles]
        expect(bundles_response.size).to eql 4
      end

      it "renders all available bundles" do
        bundles_response = json_response[:bundles]
        expect(bundles_response.first[:price]).to eql @bundle.price
      end

      it { is_expected.to respond_with :ok }
    end

    context "when there's no bundle available" do
      let(:user) { create :user }
      before do
        Bundle.all.each { |b| b.destroy }    # cleans the bundles table
        3.times { create :bundle, status: false }
        api_authorization_header user.auth_token
        get :index
      end

      it "should render an errors json" do
        expect(json_response).to have_key :errors
      end

      it "should render the json errors on why the user could not be created" do
        expect(json_response[:errors][:base]).to include I18n.t 'errors.messages.not_found'
      end

      it { should respond_with :not_found }
    end
  end

end
