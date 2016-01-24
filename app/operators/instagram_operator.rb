class InstagramOperator
  attr_reader :campaign

  # Initializes a new instance of InstagramOperator.
  #
  # @param campaign [Campaign] the campaign object.
  # @param user [User] the user object.
  # @param opts [Hash] a hash consist of required options for various types of campaign.
  # @example
  #   InstagramOperator.new(campaign, user, { instagram_access_token: "abcs..." })
  def initialize(campaign, user, opts={})
    @campaign = campaign
    @user = user
    @access_token = opts[:instagram_access_token]
  end

  # Based on the response from {#user_has_liked?} adds respective errors to
  # the campaign object if the user has not liked the target.
  #
  # @return [Boolean] true if the user has liked the target, false otherwise.
  def call
    begin
      if user_has_liked?
        return true
      else
        @campaign.errors.add(:base, :has_not_liked)
        return false
      end
    rescue Instagram::BadRequest => e
      # when user has revoked the application's access or
      #   Instagram has reset the access_token.
      if e.message.include? "access_token provided is invalid"
        @campaign.errors.add(:base, :access_token_invalid)
      # when the target got deleted and is not available anymore.
      elsif e.message.include? "invalid media id"
        @campaign.errors.add(:base, :deleted)
      else
        @campaign.errors.add(:base, :instagram_error)
      end
      return false
    rescue => e
      @campaign.errors.add(:base, :instagram_error)
      return false
    end
  end

  private

  # Checks if the user has liked the campaign's target photo on Instagram.
  #
  # @return [Boolean] true if user has liked the target, false otherwise.
  def user_has_liked?
    client = Instagram.client(access_token: @access_token)
    media = client.media_shortcode(@campaign.instagram_detail.short_code)
    media.user_has_liked
  end

end
