class Bundle < ActiveRecord::Base
  has_many :transactions
  has_many :buyers, through: :transactions, source: :user

  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :free_coins, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :coins, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
