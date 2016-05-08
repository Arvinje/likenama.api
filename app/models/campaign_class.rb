class CampaignClass < ActiveRecord::Base

  before_create :deactivate_previous_class!

  has_many :campaigns

  validates :campaign_type, presence: true
  validates :campaign_value, presence: true, numericality: { only_integer: true }
  validates :coin_user_share, presence: true, numericality: { only_integer: true }
  validates :like_user_share, presence: true, numericality: { only_integer: true }
  validates :waiting, presence: true, numericality: { only_integer: true }

  validate :values_validity

  enum status: { active: true, inactive: false }

  # Returns a hash full of fields and their states by calling
  # {Campaign.fields}.
  #
  # @return [Hash]
  def fields
    campaign = Object.const_get campaign_type
    campaign.fields(waiting == 0 ? false : true)
  end

  private

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

  # Validates the entered coin_user_share, like_user_share and campaign_value,
  # so if at all times, based on the provided payment_type, its user_share would be
  # less than campaign_value.
  #
  # @return [Boolean] false if there's an error.
  def values_validity
    begin
      case payment_type
      when 'coin'
        if coin_user_share > campaign_value
          errors.add(:coin_user_share, :must_be_less_than_campaign_value)
          return false
        end
      else
        if like_user_share > campaign_value
          errors.add(:like_user_share, :must_be_less_than_campaign_value)
          return false
        end
      end
    rescue
      return false
    end
  end

end
