class User < ActiveRecord::Base
  include PublicActivity::Common

  before_create :generate_authentication_token!

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

  validates :auth_token, uniqueness: true
  validates :like_credit, presence: true, numericality: { only_integer: true }
  validates :coin_credit, presence: true, numericality: { only_integer: true }

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, omni_id: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.omni_id = auth.uid
      user.password = Devise.friendly_token[0,20]
      user.email = "#{auth.provider}_#{auth.uid}@likenama.com"  # CAUTION: uid must be email-address-friendly
    end
  end

  def get_username_from_omniauth(auth)
    self.username = auth.info.nickname if auth.info.respond_to? :nickname
  end

  def self.find_omniauth_user(auth)
    where(provider: auth.provider, omni_id: auth.uid).first
  end

end
