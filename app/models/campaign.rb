class Campaign < ActiveRecord::Base
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  validates :type, presence: true, numericality: { only_integer: true }
  validates :like_value, presence: true, numericality: { only_integer: true }
  validates :total_likes, numericality: { only_integer: true }

  def like(user)
    if self.liking_users << user
      self.total_likes += 1
      return true
    else
      return false
    end
  end
end
