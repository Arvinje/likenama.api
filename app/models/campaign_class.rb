class CampaignClass < ActiveRecord::Base

  has_many :campaigns

  validates :campaign_type, presence: true
  validates :coin_value, presence: true, numericality: { only_integer: true }
  validates :coin_user_share, presence: true, numericality: { only_integer: true }
  validates :like_value, presence: true, numericality: { only_integer: true }
  validates :like_user_share, presence: true, numericality: { only_integer: true }
  validates :waiting, presence: true, numericality: { only_integer: true }

end
