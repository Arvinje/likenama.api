class CampaignClass < ActiveRecord::Base

  before_create :deactivate_previous_class!

  has_many :campaigns

  validates :campaign_type, presence: true
  validates :campaign_value, presence: true, numericality: { only_integer: true }
  validates :coin_user_share, presence: true, numericality: { only_integer: true }
  validates :like_user_share, presence: true, numericality: { only_integer: true }
  validates :waiting, presence: true, numericality: { only_integer: true }

  enum status: { active: true, inactive: false }

  # Makes sure that there's not any class with the same specs as
  # the current class active.
  def deactivate_previous_class!
    last_class = if waiting > 0
                  CampaignClass.active.where(campaign_type: campaign_type,
                                             payment_type: payment_type)
                                             .where.not(waiting: 0).last
                else
                  CampaignClass.active.where(campaign_type: campaign_type,
                                             payment_type: payment_type,
                                             waiting: 0).last
                end
    last_class.inactive! unless last_class.nil?
  end

end
