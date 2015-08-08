class User < ActiveRecord::Base
  before_create :generate_authentication_token!

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :uid, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:instagram]

  has_many :likes, dependent: :nullify
  has_many :liked_campaigns, through: :likes, source: :campaign
  has_many :campaigns, foreign_key: :owner_id

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

end
