class InstagramDetail < ActiveRecord::Base
  attr_accessor :url

  belongs_to :campaign, inverse_of: :instagram_detail


  validate :must_have_valid_short_code
  validates :short_code, presence: true
  validates :campaign, presence: true

  def get_url
    "http://instagram.com/p/#{self.short_code}"
  end

  def must_have_valid_short_code
    unless get_instagram_photo_url
      self.errors[:url] << "آدرس تصویر اینستاگرام اشتباه است"
    end
  end

  def get_instagram_photo_url
    begin
      set_shortcode
      client = Instagram.client
      media = client.media_shortcode(self.short_code)
      self.photo_url = media.images.standard_resolution.url
      true
    rescue
      false
    end
  end

  def set_shortcode
    begin
      self.short_code = self.url.gsub(/\s+/, '').match(/instagram.com\/p\/([^\/]*)/)[1]
    rescue
      false
    end
  end
end
