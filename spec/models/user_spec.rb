require 'rails_helper'

RSpec.describe User, type: :model do

  describe "ActiveModel validations" do
    before { @user = build :user }
    subject { @user }

    it { should respond_to :email }
    it { should respond_to :username }
    it { should respond_to :password }
    it { should respond_to :password_confirmation }
    it { should respond_to :uid }
    it { should respond_to :provider }
    it { should respond_to :omni_id }
    it { should respond_to :auth_token }
    it { should respond_to :like_credit }
    it { should respond_to :coin_credit }

  describe "ActiveModel validations" do

  end
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :like_credit }
    it { should validate_presence_of :coin_credit }

    it { should validate_numericality_of(:like_credit).only_integer }
    it { should validate_numericality_of(:coin_credit).only_integer }

    it { should validate_confirmation_of :password }

    it { should validate_uniqueness_of :email }
    it { should validate_uniqueness_of :auth_token }

    it { should allow_value('example@domain.com').for :email }

    it { should be_valid }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to have_many(:likes).dependent :nullify }
    it { is_expected.to have_many(:liked_campaigns).through(:likes).source(:campaign) }
    it { is_expected.to have_many(:campaigns).with_foreign_key(:owner_id) }
    it { is_expected.to have_many(:purchased_details).class_name('ProductDetail') }
    it { is_expected.to have_many(:purchased_products).through(:purchased_details).source(:product) }
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_many(:purchased_bundles).through(:transactions).source(:bundle) }
  end

  describe "Callbacks" do
    let(:user) { create :user }

    it { expect(user).to callback(:generate_authentication_token!).before(:create) }
  end

  describe "#buy" do
    context "when user has_enough coin credit to buy" do
      let(:user) { create :user, coin_credit: 10000 }
      let(:product) { create :product_with_details, price: 100, details_count: 3 }

      it "reduces the coin_credit by the product's price" do
        expect{ user.buy product }.to change{ user.coin_credit }.from(10000).to(9900)
        user.reload
        expect{ user.buy product }.to change{ user.coin_credit }.from(9900).to(9800)
      end

      it "adds the detail to purchased_details" do
        product_detail = product.details.available.first
        user.buy product
        user.reload
        expect(user.purchased_details).to include product_detail
      end

      it "removes the purchased details from product's available details" do
        product_detail = product.details.available.first
        user.buy product
        user.reload
        expect(product.details.available).not_to include product_detail
      end

      context "when there's only one detail left" do
        it "marks the product as not available" do
          expect(product.available).to eql true
          3.times { user.buy product }
          expect(product.available).to eql false
        end
      end

      it "returns the requested product_detail" do
        product_detail = product.details.available.first
        expect(user.buy product).to eql product_detail
      end
    end

    context "when user doesn't have enough coin credit for the product" do
      let(:user) { create :user, coin_credit: 100 }
      let(:product) { create :product_with_details, price: 200 }

      it "renders respective errors" do
        user.buy product
        expect(user.errors[:coin_credit]).to include "اعتبار شما برای خرید این محصول کافی نیست"
      end

      it "returns false" do
        expect(user.buy product).to eql false
      end
    end
  end

  describe "#generate_authentication_token!" do
    before do
      @user = create :user, auth_token: "auniquetoken123"
    end
    it "should generate a unique token" do
      allow(Devise).to receive(:friendly_token).and_return "auniquetoken123"
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "auniquetoken123"
    end

    it "should generate another token when one already has been taken" do
      existing_user = create :user, auth_token: "auniquetoken123"
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end
  end

  describe ".from_omniauth" do
    before :each do
      class Param;attr_accessor :provider, :uid;end
      @params = Param.new
      @params.provider = "instagram"
      @params.uid = "1452336"
    end

    context "when a current user signs in" do
      before :each do
        @user = create :user, provider: @params.provider, omni_id: @params.uid, email: "#{@params.provider}_#{@params.uid}@likenama.com"
      end

      it "should return a currently signed-up user" do
        expect(User.from_omniauth(@params).omni_id).to eql @user.omni_id
      end
    end

    context "when a new user registers" do
      it "should return a newly created user" do
        expect(User.from_omniauth(@params).email).to eql "#{@params.provider}_#{@params.uid}@likenama.com"
      end
    end
  end

  describe ".get_username_from_omniauth" do
    let(:user) { create :user }

    context "when there's a nickname available" do
      before do
        class Param; attr_accessor :nickname; def info; self; end; end;
        @params = Param.new
        @params.info.nickname = "mike"
        user.get_username_from_omniauth(@params)
      end

      it "assigns nickname to user's username" do
        expect(user.username).to eql "mike"
      end
    end

    context "when there isn't any nickname available" do
      before do
        class Param; def info; self; end; end;
        @params = Param.new
        user.get_username_from_omniauth(@params)
      end

      it "assigns nickname to user's username" do
        expect(user.username).to eql nil
      end
    end
  end

  describe ".find_omniauth_user" do
    before :each do
      class Param;attr_accessor :provider, :uid;end
      @params = Param.new
      @params.provider = "instagram"
      @params.uid = "1452336"
    end

    context "when a current user signs in" do
      before :each do
        @user = create :user, provider: @params.provider, omni_id: @params.uid, email: "#{@params.provider}_#{@params.uid}@likenama.com"
      end

      it "should return a currently signed-up user" do
        expect(User.find_omniauth_user(@params).omni_id).to eql @user.omni_id
      end
    end

    context "when an unknown user signs in" do
      it "should return a newly created user" do
        expect(User.find_omniauth_user(@params)).to eql nil
      end
    end
  end

end
