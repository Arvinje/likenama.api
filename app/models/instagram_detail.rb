class InstagramDetail < ActiveRecord::Base
  belongs_to :campaign

  validates :short_code, presence: true
  validates :campaign, presence: true
  validates :waiting, numericality: { only_integer: true }
end
