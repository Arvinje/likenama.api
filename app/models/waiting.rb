class Waiting < ActiveRecord::Base
  has_many :campaigns

  validates :campaign_type, presence: true
  validates :payment_type, presence: true
  validates :period, presence: true, numericality: { only_integer: true }

  def self.instagram_money_getter
    self.where(campaign_type: 'instagram', payment_type: 'money_getter').last
  end

  def self.instagram_like_getter
    self.where(campaign_type: 'instagram', payment_type: 'like_getter').last
  end
end
