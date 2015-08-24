class InstagramDetail < ActiveRecord::Base
  belongs_to :campaign, inverse_of: :instagram_detail

  validate :must_have_valid_short_code

  validates :short_code, presence: true
  validates :campaign, presence: true
  validates :photo_url, presence: true

  def must_have_valid_short_code
    unless get_instagram_photo_url
      self.errors[:short_code] << "invalid shortcode"
    end
  end

  def get_instagram_photo_url
    begin
      client = Instagram.client
      media = client.media_shortcode(self.short_code)
      self.photo_url = media.images.standard_resolution.url
      true
    rescue
      false
    end
  end
end
