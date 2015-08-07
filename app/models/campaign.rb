class Campaign < ActiveRecord::Base

  enum campaign_type: { instagram: 'instagram', web: 'web' }
  enum payment_type: { like_getter: 'like_getter', money_getter: 'money_getter' }

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  belongs_to :owner, class_name: 'User'
  has_one :instagram_detail, inverse_of: :campaign, dependent: :destroy

  validates :campaign_type, presence: true
  validates :payment_type, presence: true
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

  def check_like!(user, opts = {})
    case self.campaign_type
    when "instagram"
      begin
        client = Instagram.client(access_token: opts[:instagram_access_token])
        media = client.media_shortcode(self.instagram_detail.short_code)
        if media.user_has_liked
          self.like user
        else
          self.errors[:base] << "user has not liked the photo"
          false
        end
      rescue StandardError => e
        self.errors[:base] << e.message
        false
      end
    end
  end

end
