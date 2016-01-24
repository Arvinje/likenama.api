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

  # Retrieves the current price object based on the provided
  # campaign_type and payment_type.
  #
  # @return [Price]
  def current_price
    Price.where(campaign_type: @campaign.campaign_type,
                payment_type: @campaign.payment_type)
         .order(created_at: :desc).first
  end

  # Makes sure that campaign has enough credit
  # before creating a campaign.
  # Adds respective errors when necessary.
  def campaign_has_enough_credit?
    # if current_price.nil?
    #   binding.pry
    # end
    if @campaign.budget < current_price.campaign_value
      @campaign.errors.add(:budget, :need_more_budget)
    end
  end

  # Makes sure that user has enough credit (coin or like)
  # before creating a campaign.
  # Adds respective errors when necessary.
  def user_has_enough_credit?
    case @campaign.payment_type
    when "money_getter"
      if @campaign.budget > @campaign.owner.coin_credit
        @campaign.errors.add(:budget, :not_enough_credit)
      end
    when "like_getter"
      if @campaign.budget > @campaign.owner.like_credit
        @campaign.errors.add(:budget, :not_enough_credit)
      end
    end
  end

end