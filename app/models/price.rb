class Price < ActiveRecord::Base
  has_many  :campaigns

  validates :campaign_value, presence: true, numericality: { only_integer: true }
  validates :users_share, presence: true, numericality: { only_integer: true }
  validates :campaign_type, presence: true
  validates :payment_type, presence: true

  def self.available_prices
    [self.instagram_money_getter, self.instagram_like_getter]
  end

  def self.instagram_money_getter
    self.where(campaign_type: 'instagram', payment_type: 'money_getter').last
  end

  def self.instagram_like_getter
    self.where(campaign_type: 'instagram', payment_type: 'like_getter').last
  end
end
