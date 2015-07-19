require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build :user }
  subject { @user }

  it { should respond_to :email }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should allow_value('example@domain.com').for :email }

  it { should respond_to :password }
  it { should validate_presence_of :password }
  it { should validate_confirmation_of :password }

  it { should respond_to :password_confirmation }

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  it { should be_valid }
end
