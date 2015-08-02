require 'rails_helper'

RSpec.describe Api::V1::LikesController, type: :controller do
  describe "POST #create" do
    let(:campaign) { create :campaign }
    let(:user) { create :user }
    before do
      api_authorization_header user.auth_token
    end
    context "the post get liked successfully" do
      before do
        post :create, { campaign_id: campaign.id }
      end

      it "should like the specified campaign" do
        expect(campaign.liked_by? user).to eql true
      end

      it { should respond_with 201 }
    end
  end
end
