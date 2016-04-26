class CreateCampaign
  attr_reader :campaign

  # Initializes a new instance of CreateCampaign.
  # Creates new instance of campaign based on the declared
  # campaign_type provided with params.
  #
  # @param params [Hash] a hash of parameters provided by controller
  # @param user [User] current_user object
  def initialize(params, user)
    klass = CampaignRegistry.campaign_for(params[:campaign_type])
    @campaign = klass.new(params.except(:campaign_type))
    @campaign.owner = user
  end

  # Saves the campaign and adds errors if applicable.
  #
  # @return [Boolean] true if the operation was successful, false otherwise.
  def save
    persist!
  end

  private

  # Performs validations and saves the record.
  # Enqueues a job form downloading the cover.
  #
  # @return [Boolean] true if the operation was successful, false otherwise.
  def persist!
    begin
      ActiveRecord::Base.transaction do
        set_campaign_class!
        raise unless creation_valid?
        financial_transactions
        @campaign.save!
        @campaign.owner.save!
      end
      @campaign.fetch_cover
      true
    rescue
      false
    end
  end

  def set_campaign_class!
    begin
      @campaign.set_campaign_class!
      raise "class not available" if @campaign.campaign_class.nil?
    rescue
      @campaign.errors.add(:base, :class_not_available)
      raise "class not available"
    end
  end

  # Calls the respective validator to check validity
  # of the campaign object.
  #
  # @return [Boolean] true if it's valid, false otherwise.
  def creation_valid?
    validator = @campaign.creation_validator
    if validator.validate
      @campaign = validator.campaign
    else
      @campaign = validator.campaign
      false
    end
  end

  # Reduces owner's credit by the campaign's budget
  # based on its payment_type.
  def financial_transactions
    begin
      case @campaign.payment_type
      when "coin"
        @campaign.owner.coin_credit -= @campaign.budget
      when "like"
        @campaign.owner.like_credit -= @campaign.budget
      end
    rescue
      @campaign.errors.add(:budget, :not_a_number)
      raise "not a number"
    end
  end

end
