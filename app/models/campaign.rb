class Campaign < ActiveRecord::Base
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes

  validates :type_id, presence: true, numericality: { only_integer: true }
  validates :like_value, presence: true, numericality: { only_integer: true }
  validates :total_likes, numericality: { only_integer: true }
end
