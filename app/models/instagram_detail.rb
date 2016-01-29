class InstagramDetail < ActiveRecord::Base
  attr_accessor :url

  belongs_to :campaign, inverse_of: :instagram_detail

  validates :short_code, presence: true
  validates :campaign, presence: true

  def get_url
    "http://instagram.com/p/#{self.short_code}"
  end

end
