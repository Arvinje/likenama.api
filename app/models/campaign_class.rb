class CampaignClass < ActiveRecord::Base

  has_many :campaigns

  validates :campaign_type, presence: true
  validates :campaign_value, presence: true, numericality: { only_integer: true }
  validates :coin_user_share, presence: true, numericality: { only_integer: true }
  validates :like_user_share, presence: true, numericality: { only_integer: true }
  validates :waiting, presence: true, numericality: { only_integer: true }

  enum status: { active: true, inactive: false }

end
