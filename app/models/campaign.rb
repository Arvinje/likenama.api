class Campaign < ActiveRecord::Base

  enum campaign_type: { like_getter: 0, money_getter: 1 }

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  belongs_to :owner, class_name: 'User'
  has_many :instagram_details, dependent: :destroy

  validates :campaign_type, presence: true
  validates :like_value, presence: true, numericality: { only_integer: true }
  validates :total_likes, numericality: { only_integer: true }
  validates :owner, presence: true

  def like(user)
    unless self.liking_users.include? user
      if self.liking_users << user
        self.total_likes += 1
        return true
      else
        return false
      end
    end
    return true
  end

  def liked_by?(user)
    if self.liking_users.include? user
      true
    else
      false
    end
  end

end
