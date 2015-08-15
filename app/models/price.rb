class Price < ActiveRecord::Base
  has_many  :campaigns

  enum campaign_type: { instagram: 'instagram', web: 'web' }
  enum payment_type: { money_getter: 'money_getter', like_getter: 'like_getter' }

  validates :campaign_value, presence: true, numericality: { only_integer: true }
  validates :users_share, presence: true, numericality: { only_integer: true }
  validates :campaign_type, presence: true
  validates :payment_type, presence: true
end
