class User < ActiveRecord::Base
  include PublicActivity::Common

  before_validation :generate_authentication_token!, on: :create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :uid, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :omniauthable, omniauth_providers: [:instagram]

  has_many :likes, dependent: :nullify
  has_many :liked_campaigns, through: :likes, source: :campaign
  has_many :campaigns, foreign_key: :owner_id
  has_many :purchased_details, class_name: "ProductDetail"
  has_many :purchased_products, through: :purchased_details, source: :product
  has_many :bundle_purchases
  has_many :purchased_bundles, through: :bundle_purchases, source: :bundle
  has_many :reports, dependent: :destroy
  has_many :reported_campaigns, through: :reports, source: :campaign
  has_many :messages
  has_many :gifts, foreign_key: :email, primary_key: :email

  validates :auth_token, uniqueness: true
  validates :like_credit, presence: true, numericality: { only_integer: true }
  validates :coin_credit, presence: true, numericality: { only_integer: true }

  # Authenticates the user via Omniauth.
  # Creates a user if it's the first time signing in.
  # Gets the user if the record is persisted.
  #
  # @return [User] returns the user instance.
  def self.from_omniauth(auth)
    where(provider: auth.provider, omni_id: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.omni_id = auth.uid
      user.password = Devise.friendly_token[0,20]
      user.email = "#{auth.provider}_#{auth.uid}@likenama.com"  # CAUTION: uid must be email-address-friendly
      user.username = auth.info.nickname
    end
  end

  # Gets the user based on Omniauth credentials
  # Used for authenticating user when signing in dashboard.
  def self.find_omniauth_user(auth)
    where(provider: auth.provider, omni_id: auth.uid).first
  end

  # Redeems gifts of the user if there's one available
  # by adding coin and like credit to the account.
  #
  # @return [Boolean] true if user has saved successfully, false otherwise.
  def redeem_gift!
    gift = gifts.active.first
    if gift
      self.coin_credit += gift.coin_credit
      self.like_credit += gift.like_credit
      gift.redeemed!
    end
    self.save
  end

  private

  # Generates an authentication token.
  #
  # @return [String] returns an authentication token.
  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while User.exists?(auth_token: auth_token)
  end

end
