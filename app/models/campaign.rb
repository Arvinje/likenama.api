class Campaign < ActiveRecord::Base

  before_save :set_price
  before_validation :set_availability

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  belongs_to :owner, class_name: 'User'
  has_one :instagram_detail, inverse_of: :campaign, dependent: :destroy
  belongs_to :price

  # Edit these two when adding new types, also add new postgres enums when needed
  validates :campaign_type, presence: true, inclusion: { in: ['instagram'], message: "is not a valid campaign_type" }
  validates :payment_type, presence: true, inclusion: { in: ['money_getter', 'like_getter'], message: "is not a valid payment_type" }
  validates :total_likes, presence: true, numericality: { only_integer: true }
  validates :budget, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :owner, presence: true

  validate  :must_have_one_association
  #validate  :must_have_enough_credit

  accepts_nested_attributes_for :instagram_detail, update_only: true, reject_if: :instagram_only

  scope :available, -> { where available: true }
  scope :finished, -> { where available: false }

  def set_availability
    self.available = true if self.available.nil?
  end

  def must_have_enough_credit
    case self.payment_type
    when "money_getter"
      if self.budget > self.owner.coin_credit   # when user has not enough credit to create a campaign
        self.errors[:budget] << "user doesn't have enough credit"
      end
      if self.budget < Price.instagram_money_getter.campaign_value   # when the budget is not enough even for a like
        self.errors[:budget] << "campaign doesn't have enough budget"
      end
    when "like_getter"
      if self.budget > self.owner.like_credit   # when user has not enough credit to create a campaign
        self.errors[:budget] << "user doesn't have enough credit"
      end
      if self.budget < Price.instagram_money_getter.campaign_value   # when the budget is not enough even for a like
        self.errors[:budget] << "campaign doesn't have enough budget"
      end
    end
  end

  def set_price
    case self.campaign_type
    when 'instagram'
      if self.payment_type == 'money_getter'
        self.price = Price.instagram_money_getter
      elsif self.payment_type == 'like_getter'
        self.price = Price.instagram_like_getter
      end
    end
  end

  def self.for_user(user) # Returns available campaigns that are not liked by the user
    (self.available - self.available.joins(:likes).where('likes.user_id = ?', user.id)).first
  end

  def instagram_only
    self.campaign_type == "instagram" ? false : true
  end

  def must_have_one_association
    if self.instagram_detail.nil? # && self.web_detail.nil? && ...
      self.errors[:base] << "must have some details"
    end
  end

  def like(user)
    unless self.liked_by? user
      if self.liking_users << user
        self.total_likes += 1
        case self.payment_type  # whether its payment_type is like_getter or money_getter
        when "like_getter"
          user.like_credit += self.price.users_share   # adds like_credit based on the price's users_share
          self.budget -= self.price.campaign_value     # Decreases campaign budget by the price's campaign_value
        when "money_getter"
          user.coin_credit += self.price.users_share   # adds coin_credit based on the price's users_share
          self.budget -= self.price.campaign_value     # Decreases campaign budget by the price's campaign_value
        end
        self.save
        user.save
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

  def check_like!(user, opts = {})    # Performs special ops based on campaign_type
    unless self.price.campaign_value <= self.budget
      self.errors[:base] << "the campaign's ran out of budget"
      false
    end
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
