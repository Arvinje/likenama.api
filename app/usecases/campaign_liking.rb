class CampaignLiking
  attr_reader :campaign

  # Initializes a new instance of CampaignLiking.
  #
  # @param campaign [Campaign] the campaign object.
  # @param user [User] the user object.
  # @param opts [Hash] a hash consist of required options for various types of campaign.
  # @example
  #   CampaignLiking.new(campaign, user, { instagram_access_token: "abcs..." })
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
    return false unless operator_response
    persist!
  end

  private

  # Checks whether the user has liked the campaign before or not.
  #
  # @return [Boolean] true when the user has already liked the campaign, false otherwise.
  def has_liked?
    Like.exists?(campaign_id: @campaign.id, user_id: @user.id)
  end

  # Initializes and calls the respective operator to
  # check whether the user has liked the target or not.
  #
  # @return [Campaign, false] the campaign object when operator's response is true, false otherwise.
  def operator_response
    # selects right operator based on the campaign's campaign_type.
    operator_class = OperatorRegistry.operator_for @campaign.campaign_type
    operator = operator_class.new(campaign: @campaign, user: @user, options: @opts)
    operator.liked? ? @campaign = operator.campaign : false
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
    rescue
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
    case @campaign.payment_type
    when "like_getter"
      @user.like_credit += @campaign.price.users_share
      @campaign.budget -= @campaign.price.campaign_value
    when "money_getter"
      @user.coin_credit += @campaign.price.users_share
      @campaign.budget -= @campaign.price.campaign_value
    end
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
    unless @campaign.price.campaign_value <= @campaign.budget
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
      return false
    when 'pending'
      @campaign.errors.add(:base, :not_verified)
      return false
    when 'check_needed'
      @campaign.errors.add(:base, :not_verified)
      return false
    when 'ended'
      @campaign.errors.add(:base, :no_longer_available)
      return false
    end
    return true
  end

  # Checks if the duration between last like and current like is valid
  #
  # @return true if the duration is valid, false otherwise.
  def period_valid?
    last_like = Like.where(user: @user).order(created_at: :desc).first
    return true if last_like.nil?
    (Time.current - last_like.created_at) > last_like.campaign.waiting.period
  end

  # Marks the campaign unavailable if the remaining budget is not enought even for a like.
  #
  # @return [false]
  def check_campaigns_availability
    @campaign.ended! if @campaign.budget < @campaign.price.campaign_value
  end

end
