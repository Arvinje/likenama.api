class Price < ActiveRecord::Base
  has_many  :campaigns

  enum campaign_type: { instagram: 'instagram', web: 'web' }

  validates :campaign_value, presence: true, numericality: { only_integer: true }
  validates :users_share, presence: true, numericality: { only_integer: true }
end
