class Campaign < ActiveRecord::Base

  before_save :set_like_value

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  belongs_to :owner, class_name: 'User'
  has_one :instagram_detail, inverse_of: :campaign, dependent: :destroy

  # Edit these two when adding new types, also add new postgres enums when needed
  validates :campaign_type, presence: true, inclusion: { in: ['instagram'], message: "is not a valid campaign_type" }
  validates :payment_type, presence: true, inclusion: { in: ['money_getter', 'like_getter'], message: "is not a valid payment_type" }
  validates :total_likes, presence: true, numericality: { only_integer: true }
  validates :owner, presence: true

  validate  :must_have_one_association

  accepts_nested_attributes_for :instagram_detail, update_only: true, reject_if: :instagram_only

  def self.for_user(user) # Returns campaigns that are not liked by the user. Replace self.all later with a correctly scoped Campaign
    (self.all - self.joins(:likes).where('likes.user_id = ?', user.id)).first
  end

  def instagram_only
    self.campaign_type == "instagram" ? false : true
  end

  def must_have_one_association
    if self.instagram_detail.nil? # && self.web_detail.nil? && ...
      self.errors[:base] << "must have some details"
    end
  end

  def set_like_value
    case self.campaign_type
    when "instagram"
      if self.payment_type == "money_getter"
        self.like_value = KeyValue.instagram_money_getter_value
      elsif self.payment_type == "like_getter"
        self.like_value = KeyValue.instagram_like_getter_value
      end
    end
  end

  def like(user)
    unless self.liked_by? user
      if self.liking_users << user
        self.total_likes += 1
        case self.payment_type  # whether its payment_type is like_getter or money_getter
        when "like_getter"
          user.like_credit += self.like_value   # adds like_credit based on campaign's like_value
        when "money_getter"
          user.coin_credit += self.like_value   # adds coin_credit based on campaign's like_value
        end
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
        if media.user_has_liked   # returns true if the user has liked the Instagram photo, otherwise returns false
          self.like user
        else
          self.errors[:base] << "user has not liked the photo"
          false
        end
      rescue StandardError => e
        self.errors[:base] << e.message   # controller provides this error as the reason to the request
        false
      end
    end
  end

end
