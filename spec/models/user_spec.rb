require 'rails_helper'

RSpec.describe User, type: :model do

  describe "ActiveModel validations" do
    before { @user = build :user }
    subject { @user }

    it { is_expected.to respond_to :email }
    it { is_expected.to respond_to :username }
    it { is_expected.to respond_to :password }
    it { is_expected.to respond_to :password_confirmation }
    it { is_expected.to respond_to :uid }
    it { is_expected.to respond_to :provider }
    it { is_expected.to respond_to :omni_id }
    it { is_expected.to respond_to :auth_token }
    it { is_expected.to respond_to :like_credit }
    it { is_expected.to respond_to :coin_credit }

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
    it { is_expected.to validate_presence_of :like_credit }
    it { is_expected.to validate_presence_of :coin_credit }

    it { is_expected.to validate_numericality_of(:like_credit).only_integer }
    it { is_expected.to validate_numericality_of(:coin_credit).only_integer }

    it { is_expected.to validate_confirmation_of :password }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it { is_expected.to allow_value('example@domain.com').for :email }

    it { is_expected.to be_valid }
  end

  describe "ActiveRecord associations" do
    it { is_expected.to have_many(:likes).dependent :nullify }
    it { is_expected.to have_many(:liked_campaigns).through(:likes).source(:campaign) }
    it { is_expected.to have_many(:campaigns).with_foreign_key(:owner_id) }
    it { is_expected.to have_many(:purchased_details).class_name('ProductDetail') }
    it { is_expected.to have_many(:purchased_products).through(:purchased_details).source(:product) }
    it { is_expected.to have_many(:bundle_purchases) }
    it { is_expected.to have_many(:purchased_bundles).through(:bundle_purchases).source(:bundle) }
    it { is_expected.to have_many(:reports).dependent :destroy }
    it { is_expected.to have_many(:reported_campaigns).through(:reports).source(:campaign) }
    it { is_expected.to have_many(:messages) }
    it { is_expected.to have_many(:gifts).with_foreign_key('email').with_primary_key('email') }
  end

  describe "Callbacks" do
    let(:user) { create :user }

    it { expect(user).to callback(:generate_authentication_token!).before(:validation).on(:create) }
  end

  describe ".from_omniauth" do
    before :each do
      class Param;attr_accessor :provider, :uid, :info;end
      class Info;attr_accessor :nickname;end
      @params = Param.new
      @params.provider = "instagram"
      @params.uid = "1452336"
      @params.info = Info.new
      @params.info.nickname = "usrnm"
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

  describe "#redeem_gift!" do
    context "when there's an active gift for the user" do
      before do
        @user = create :user
        @gift = create :gift, email: @user.email,
                              duration: Date.yesterday..Date.tomorrow
      end

      it "adds gift coin_credit to the account" do
        expect{ @user.redeem_gift! }.to change{ @user.coin_credit }.by @gift.coin_credit
      end

      it "adds gift like_credit to the account" do
        expect{ @user.redeem_gift! }.to change{ @user.like_credit }.by @gift.like_credit
      end

      it "marks gift as redeemed" do
        @user.redeem_gift!
        expect(@gift.reload.redeemed?).to be true
      end
    end

    context "when there's no an active gift for the user" do
      before do
        @user = create :user
        @gift = create :gift, email: @user.email,
                              duration: 3.days.ago.to_date..Date.yesterday
      end

      it "adds gift coin_credit to the account" do
        expect{ @user.redeem_gift! }.to change{ @user.coin_credit }.by 0
      end

      it "adds gift like_credit to the account" do
        expect{ @user.redeem_gift! }.to change{ @user.like_credit }.by 0
      end

      it "keeps gift as available" do
        @user.redeem_gift!
        expect(@gift.reload.available?).to be true
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
