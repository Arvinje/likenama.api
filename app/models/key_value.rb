class KeyValue < ActiveRecord::Base

  validates :key, presence: true
  validates :value, presence: true, numericality: true

  scope :instagram_money_getter_value, -> { find_by(key: "InstagramMoneyGetterLikeValue").value }
  scope :instagram_like_getter_value, -> { find_by(key: "InstagramLikeGetterLikeValue").value }
end
