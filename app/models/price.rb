class Price < ActiveRecord::Base
  has_many  :campaigns

  validates :campaign_value, presence: true, numericality: { only_integer: true }
  validates :users_share, presence: true, numericality: { only_integer: true }
end
