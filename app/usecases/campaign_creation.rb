class CampaignCreation
  attr_reader :campaign, :detail

  # Initializes a new instance of CampaignCreation.
  # Creates new instances of campaign and detail based on the declared
  # campaign_type provided with params.
  #
  # @param params [Hash] a hash of parameters provided by controller
  # @param user [User] current_user object
  def initialize(params, user)
    @campaign = user.campaigns.build(params.except(:detail))
    @detail = detail_class.new(params[:detail])
    @detail.campaign = @campaign
  end

  # Saves the models and adds errors if applicable.
  #
  # @return [Boolean] true if the operation was successful, false otherwise.
  def save
    persist!
  end

  private

  # Selects respective detail class based on the provided campaign_type.
  #
  # @return a detail class
  def detail_class
    return OperatorRegistry.detail_for("") if @campaign.campaign_type.nil?
    OperatorRegistry.detail_for(@campaign.campaign_type)
  end

  # Selects respective operator class based on the provided campaign_type.
  #
  # @return an operator class
  def operator_class
    return OperatorRegistry.operator_for("") if @campaign.campaign_type.nil?
    OperatorRegistry.operator_for(@campaign.campaign_type)
  end

  # Saves the both models and handles possible errors.
  # @return [Boolean] true if the operation was successful, false otherwise.
  def persist!
    begin
      ActiveRecord::Base.transaction do
        @campaign.save!
        raise unless target_valid?
        @detail.save!
      end
      true
    rescue
      merge_errors
      false
    end
  end

  # Merges detail errors with the parent campaign
  # Also handles the situation when the operation was terminated
  # before validating the detail.
  def merge_errors
    @detail.valid? if @detail.errors.blank?
    @detail.errors.messages.each_pair do |attr,msg_arr|
       msg_arr.each do |msg|
         @campaign.errors.add("detail.#{attr}".to_sym, msg)
       end
    end
  end

  # Initializes and calls the respective operator to check validity
  # of the detail object.
  #
  # @return [Boolean] true if it's valid, false otherwise.
  def target_valid?
    object = operator_class.new(detail: @detail)
    result = object.valid?
    @detail = object.detail unless result
    return result
  end

end
