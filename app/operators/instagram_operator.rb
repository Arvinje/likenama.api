class InstagramOperator
  attr_reader :campaign, :detail

  # Initializes a new instance of InstagramOperator.
  #
  # @param params [Hash] a hash consist of required options for various types of campaign.
  # @example
  #   InstagramOperator.new(campaign: campaign, user: user, instagram_access_token: "abcs...")
  def initialize(params={})
    @campaign = params[:campaign]
    @user = params[:user]
    @detail = params[:detail]
    @access_token = params[:options][:instagram_access_token] if params[:options]
  end

  # Based on the response from {#user_has_liked?} adds respective errors to
  # the campaign object if the user has not liked the target.
  #
  # @return [Boolean] true if the user has liked the target, false otherwise.
  def liked?
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
        @campaign.check_needed!
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

  # Checks if the target is a valid Instagram photo,
  # then adds the photo_url to the provided detail.
  # Otherwise adds the respective error to the detail.
  #
  # @return [Boolean] true if it's a valid Instagram photo, false otherwise.
  def valid?
    unless target_valid?
      @detail.errors.add(:url, :wrong_instagram_url)
      return false
    end
    true
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

  # Checks if the target is a valid Instagram photo,
  # then adds the photo_url to the provided detail.
  #
  # @return [Boolean] true if it's a valid Instagram photo, false otherwise.
  def target_valid?
    begin
      return false unless set_shortcode
      client = Instagram.client
      media = client.media_shortcode(@detail.short_code)
      @detail.photo_url = media.images.standard_resolution.url
      true
    rescue
      false
    end
  end

  # Extracts the instagram short_code from the provided url
  #
  # @return [False, String] returns the short_code if it's a valid url, false otherwise.
  def set_shortcode
    begin
      @detail.short_code = @detail.url.gsub(/\s+/, '').match(/instagram.com\/p\/([^\/]*)/)[1]
    rescue
      false
    end
  end

end
