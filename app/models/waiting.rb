class Waiting < ActiveRecord::Base
  has_many :campaigns

  validates :campaign_type, presence: true
  validates :payment_type, presence: true
  validates :period, presence: true, numericality: { only_integer: true }

end
