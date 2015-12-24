class User < ActiveRecord::Base
  before_create :generate_authentication_token!

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :uid, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :omniauthable, omniauth_providers: [:instagram]

  has_many :likes, dependent: :nullify
  has_many :liked_campaigns, through: :likes, source: :campaign
  has_many :campaigns, foreign_key: :owner_id
  has_many :purchases
  has_many :purchased_products, through: :purchases, source: :product_detail
  has_many :transactions
  has_many :purchased_bundles, through: :transactions, source: :bundle

  validates :auth_token, uniqueness: true
  validates :like_credit, presence: true, numericality: { only_integer: true }
  validates :coin_credit, presence: true, numericality: { only_integer: true }

  def buy(product)
    if product.price <= self.coin_credit
      self.coin_credit -= product.price   # reduces user's coin_credit by the product's price
      requested_detail = product.details.available.first
      self.purchased_products << requested_detail   # adds the detail to purchased_products of the user
      requested_detail.available = false    # makes the details unavailable
      requested_detail.save
      self.save
      if product.details.available.blank?   # makes the product unavailable when there's no more details left
        product.available = false
        product.save
      end
      requested_detail
    else
      self.errors[:coin_credit] << "اعتبار شما برای خرید این محصول کافی نیست"
      false
    end
  end

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
