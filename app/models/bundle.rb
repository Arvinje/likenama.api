class Bundle < ActiveRecord::Base
  has_many :bundle_purchases
  has_many :buyers, through: :bundle_purchases, source: :user

  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :coins, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :free_coins, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  enum status: { active: true, inactive: false }
end
