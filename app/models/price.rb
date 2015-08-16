class Price < ActiveRecord::Base
  has_many  :campaigns

  enum campaign_type: { instagram: 'instagram', web: 'web' }
  enum payment_type: { money_getter: 'money_getter', like_getter: 'like_getter' }

  validates :campaign_value, presence: true, numericality: { only_integer: true }
  validates :users_share, presence: true, numericality: { only_integer: true }
  validates :campaign_type, presence: true
  validates :payment_type, presence: true

  scope :instagram_money_getter, -> { where(campaign_type: 'instagram', payment_type: 'money_getter').last }
  scope :instagram_like_getter, -> { where(campaign_type: 'instagram', payment_type: 'like_getter').last }
end
