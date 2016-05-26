class InstagramLikeValidator
  attr_reader :campaign

  def initialize(campaign, user, options)
    @campaign = campaign
    @user = user
    @access_token = options[:access_token]
  end

  # Based on the response from {#user_has_liked?} adds respective errors to
  # the campaign object if the user has not liked the target.
  #
  # @return [Boolean] true if the user has liked the target, false otherwise.
  def validate
    begin
      if user_has_liked?
        return true
      else
        @campaign.errors.add(:base, :has_not_liked)
        return false
      end
    rescue Instagram::BadRequest => e
      Rails.logger.error e
      # when user has revoked the application's access or
      #   Instagram has reset the access_token.
      if e.message.include? "access_token provided is invalid"
        @campaign.errors.add(:base, :access_token_invalid)
      # when the target got deleted and is not available anymore.
      elsif e.message.include? "invalid media id"
        @campaign.check_needed!
        @campaign.errors.add(:base, :deleted)
      else
        @campaign.errors.add(:base, :instagram_error)
      end
      return false
    rescue => e
      Rails.logger.error e
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
    media = client.media_shortcode(@campaign.target)
    media.user_has_liked
  end

end
