class Campaign < ActiveRecord::Base

  enum campaign_type: { like_getter: 'like_getter', money_getter: 'money_getter' }

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  belongs_to :owner, class_name: 'User'
  has_one :instagram_detail, inverse_of: :campaign, dependent: :destroy

  validates :campaign_type, presence: true
  validates :like_value, presence: true, numericality: { only_integer: true }
  validates :total_likes, numericality: { only_integer: true }
  validates :owner, presence: true

  accepts_nested_attributes_for :instagram_detail

  def like(user)
    unless self.liked_by? user
      if self.liking_users << user
        self.total_likes += 1
        true
      else
        false
      end
    end
    true
  end

  def liked_by?(user)
    Like.exists?(campaign_id: self.id, user_id: user.id)
  end

end
