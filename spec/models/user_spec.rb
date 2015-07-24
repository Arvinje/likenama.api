require 'rails_helper'

RSpec.describe User, type: :model do

  describe "ActiveModel validations" do
    before { @user = build :user }
    subject { @user }

    it { should respond_to :email }
    it { should respond_to :password }
    it { should respond_to :password_confirmation }
    it { should respond_to :uid }
    it { should respond_to :provider }
    it { should respond_to :omni_id }

    it { should validate_presence_of :email }
    it { should validate_presence_of :password }

    it { should validate_confirmation_of :password }

    it { should validate_uniqueness_of :email }

    it { should allow_value('example@domain.com').for :email }

    it { should be_valid }
  end

  describe "ActiveRecord associations" do
    it { should have_many(:likes).dependent :nullify }
    it { should have_many(:campaigns).through(:likes) }
  end

  describe ".from_omniauth" do
    before :each do
      class Param;attr_accessor :provider, :uid;end
      @params = Param.new
      @user = create :user, provider: "instagram", omni_id: "1456", email: "instagram_1456@likenama.com"
    end

    context "when a current user signs in" do
      before :each do
        @params.provider = "instagram"
        @params.uid = "1456"
      end

      it "should return a currently signed-up user" do
        expect(User.from_omniauth(@params).omni_id).to eql @user.omni_id
      end
    end

    context "when a new user registers" do
      before :each do
        @params.provider = "instagram"
        @params.uid = "1452336"
      end

      it "should return a newly created user" do
        expect(User.from_omniauth(@params).email).to eql "#{@params.provider}_#{@params.uid}@likenama.com"
      end
    end
  end

end
