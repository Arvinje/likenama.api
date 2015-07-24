class Campaign < ActiveRecord::Base
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  belongs_to :owner, class_name: 'User'

  validates :campaign_type, presence: true, numericality: { only_integer: true }
  validates :like_value, presence: true, numericality: { only_integer: true }
  validates :total_likes, numericality: { only_integer: true }
  validates :owner, presence: true

  def like(user)
    if self.liking_users << user
      self.total_likes += 1
      return true
    else
      return false
    end
  end

  def liked_by?(user)
    if self.liking_users.include? user
      true
    else
      false
    end
  end
end
