class LikeCampaign
  attr_reader :campaign

  # Initializes a new instance of LikeCampaign.
  #
  # @param campaign [Campaign] the campaign object.
  # @param user [User] the user object.
  # @param opts [Hash] a hash consist of required options for various types of campaign.
  # @example
  #   LikeCampaign.new(campaign, user, { instagram_access_token: "abcs..." })
  def initialize(campaign, user, opts={})
    @campaign = campaign
    @user = user
    @opts = opts
  end

  # Puts a like on the specified campaign by the user.
  #
  # @return [Boolean] true when the operation is successful, false otherwise.
  def like!
    return true if has_liked?
    return false unless valid?
    return false unless validator_response
    persist!
  end

  private

  # Checks whether the user has liked the campaign before or not.
  #
  # @return [Boolean] true when the user has already liked the campaign, false otherwise.
  def has_liked?
    Like.exists?(campaign_id: @campaign.id, user_id: @user.id)
  end

  # Initializes and calls the respective validator to
  # check whether the user has liked the target or not.
  #
  # @return [Campaign, false] the campaign object when validator's response is true, false otherwise.
  def validator_response
    klass = @campaign.liking_validator
    validator = klass.new(@campaign, @user, @opts)
    if validator.validate
      @campaign = validator.campaign
    else
      @campaign = validator.campaign
      false
    end
  end

  # Creates the join model instance and calls {#credential_operations} to
  # perform credential operations.
  #
  # @return [Boolean] true if the operation's successful, false otherwise.
  def persist!
    begin
      ActiveRecord::Base.transaction do
        @user.liked_campaigns << @campaign
        credential_operations
        @user.save!
        @campaign.save!
      end
      return true
    rescue => e
      Rails.logger.error e
      Like.find(campaign_id: @campaign.id, user_id: @user.id).destroy if has_liked?
      @campaign.errors.add(:base, :server_side_error)
      return false
    end
  end

  # Performs respective credit-related actions for liking a campaign.
  # Increases user's credit by campaign's users_share.
  # Decreases campaign's budget by campaign's campaign_value.
  # Calls {#check_campaigns_availability} to check the campaign's availability.
  #
  # @return [Boolean]
  def credential_operations
    case @campaign.campaign_class.payment_type
    when "like"
      @user.like_credit += @campaign.campaign_class.like_user_share
    when "coin"
      @user.coin_credit += @campaign.campaign_class.coin_user_share
    end
    @campaign.budget -= @campaign.campaign_class.campaign_value
    check_campaigns_availability
  end

  # Validates the campaign and the user.
  # Checks if:
  # 1. the campaign's available
  # 2. the campaign has enough budget for a like
  # 3. the duration between last like and current like is valid, according to the waiting period.
  #
  # @return [Boolean] true if the campaign and the user are both valid, false otherwise.
  def valid?
    # checks if campaign is available
    return false unless status_valid?

    # checks if campaign has enough budget
    unless @campaign.campaign_class.campaign_value <= @campaign.budget
      @campaign.errors.add(:base, :budget_run_out)
      return false
    end

    # checks the duration between each like
    unless period_valid?
      @campaign.errors.add(:base, :have_to_wait)
      return false
    end
    return true
  end

  # Appends respective errors when the campaign
  # is not available.
  #
  # @return [Boolean] true when campaign is valid, false otherwise.
  def status_valid?
    case @campaign.status
    when 'rejected'
      @campaign.errors.add(:base, :not_verified)
      false
    when 'pending'
      @campaign.errors.add(:base, :not_verified)
      false
    when 'check_needed'
      @campaign.errors.add(:base, :not_verified)
      false
    when 'ended'
      @campaign.errors.add(:base, :no_longer_available)
      false
    when nil
      @campaign.errors.add(:base, :not_verified)
      false
    else
      true
    end
  end

  # Checks if the duration between last like and current like is valid
  #
  # @return true if the duration is valid, false otherwise.
  def period_valid?
    last_like = Like.where(user: @user).order(created_at: :desc).first
    return true if last_like.nil?
    (Time.current - last_like.created_at) > last_like.campaign.campaign_class.waiting
  end

  # Marks the campaign unavailable if the remaining budget is not enought even for a like.
  #
  # @return [false]
  def check_campaigns_availability
    @campaign.ended! if @campaign.budget < @campaign.campaign_class.campaign_value
  end

end
