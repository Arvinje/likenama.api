class CampaignValidator

  # Initializes a new instance of CampaignValidator
  #
  # @param campaign [Campaign] the new non-persisted campaign object
  def initialize(campaign)
    @campaign = campaign
  end

  # Performs the following validations on the campaign object:
  #   1. If campaign has enough credit for at least a like
  #   2. If the owner has enough credit to create a campaign
  # Note that the validations run only when campaign is being created.
  def validate
    begin
      return if @campaign.persisted? # checks only on create
      campaign_has_enough_credit?
      user_has_enough_credit?
      @campaign
    rescue
      return
    end
  end

  private

  # Makes sure that campaign has enough credit
  # before creating a campaign.
  # Adds respective errors when necessary.
  def campaign_has_enough_credit?
    if @campaign.budget < @campaign.campaign_class.campaign_value
      @campaign.errors.add(:budget, :need_more_budget)
    end
  end

  # Makes sure that user has enough credit (coin or like)
  # before creating a campaign. Gets performed after financial_transactions in CreateCampaign.
  # Adds respective errors when necessary.
  def user_has_enough_credit?
    case @campaign.payment_type
    when "coin"
      if @campaign.owner.coin_credit < 0
        @campaign.errors.add(:budget, :not_enough_credit)
      end
    when "like"
      if @campaign.owner.like_credit < 0
        @campaign.errors.add(:budget, :not_enough_credit)
      end
    end
  end

end
