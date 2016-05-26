class InstagramPhotoValidator
  attr_reader :campaign

  def initialize(campaign)
    @campaign = campaign
  end

  # Fetches the Instagram photo from the server
  #
  # @return [Boolean] true if the operation was successful, false otherwise
  def validate
    begin
      set_target!
      media = Instagram.client.media_shortcode(@campaign.target)
      media.images.standard_resolution.url
      true
    rescue => e
      Rails.logger.error e
      @campaign.errors.add(:target_url, :wrong_instagram_url)
      false
    end
  end

  private

  # Extracts photo's short_code from the provided url, sets it as the target
  #
  # @return [False, String] returns the short_code if it's a valid url, false otherwise.
  def set_target!
    @campaign.target = @campaign.target_url.gsub(/\s+/, '').match(/instagram.com\/p\/([^\/]*)/)[1]
  end

end
