class Campaign < ActiveRecord::Base

  before_save :set_price
  before_save :set_waiting

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  belongs_to :owner, class_name: 'User'
  has_one :instagram_detail, inverse_of: :campaign, dependent: :destroy
  belongs_to :price
  belongs_to :waiting

  # Edit these two when adding new types, also add new postgres enums when needed
  validates :campaign_type, presence: true, inclusion: { in: ['instagram'], message: "is not a valid campaign_type" }
  validates :payment_type, presence: true, inclusion: { in: ['money_getter', 'like_getter'], message: "is not a valid payment_type" }
  validates :budget, presence: true, numericality: { only_integer: true }
  validates :owner, presence: true

  validate  :must_have_one_association
  validate  :must_have_enough_credit, on: :create # Must validate just on create, 'cause prevent the last like to be persistent.

  accepts_nested_attributes_for :instagram_detail, update_only: true, reject_if: :instagram_only

  scope :available, -> { where available: true }
  scope :finished, -> { where available: false }

  # Sets the day's campaign waiting based on campaign/payment type.
  def set_waiting
    self.waiting = Waiting.where(campaign_type: self.campaign_type, payment_type: self.payment_type).last
  end

  # Sets the day's campaign price based on campaign/payment type.
  def set_price
    self.price = Price.where(campaign_type: self.campaign_type, payment_type: self.payment_type).last
  end

  # Makes sure that user has enough credit (coin or like)
  # before creating a campaign.
  def must_have_enough_credit
    begin
      case self.payment_type
      when "money_getter"
        if self.budget > self.owner.coin_credit   # when user has not enough credit to create a campaign
          self.errors[:budget] << "شما اعتبار کافی ندارید"
        end
        if self.budget < Price.instagram_money_getter.campaign_value   # when the budget is not enough even for a like
          self.errors[:budget] << "باید اعتبار بیشتری برای کمپین خود اختصاص دهید"
        end
      when "like_getter"
        if self.budget > self.owner.like_credit   # when user has not enough credit to create a campaign
          self.errors[:budget] << "شما اعتبار کافی ندارید"
        end
        if self.budget < Price.instagram_money_getter.campaign_value   # when the budget is not enough even for a like
          self.errors[:budget] << "باید اعتبار بیشتری برای کمپین خود اختصاص دهید"
        end
      end
    rescue
      return
    end
  end

  def self.for_user(user) # Returns available campaigns that are not liked by the user
    self.available.where("id not in (select campaign_id from likes where user_id = ? and available = true)", user.id).first
  end

  def instagram_only
    self.campaign_type == "instagram" ? false : true
  end

  def must_have_one_association
    if self.instagram_detail.nil? # && self.web_detail.nil? && ...
      self.errors[:base] << "اطلاعات واردشده برای ساخت کمپین کافی نیست"
    end
  end

  # Performs validations and special ops based on campaign_type
  # For Instagram, it checks if the user has liked the photo or not
  def check_like!(user, opts = {})
    # all the validations that has to be performed before going further
    return false unless self.validate_before_like user
    case self.campaign_type
    when "instagram"
      self.check_instagram_like user, opts[:instagram_access_token]
    end
  end

  # Performs Instagram-specific validations
  # Checks if the user has already liked the photo on Instagram
  def check_instagram_like(user, instagram_access_token)
    begin
      client = Instagram.client(access_token: instagram_access_token)
      media = client.media_shortcode(self.instagram_detail.short_code)
      if media.user_has_liked == true   # returns true if the user has liked the Instagram photo, otherwise returns false
        self.like user
      elsif media.user_has_liked.nil?
        return false
      else
        self.errors[:base] << "این کمپین لایک نشده است"
        return false
      end
    rescue Instagram::BadRequest => e
      if e.message.include? "access_token provided is invalid"
        self.errors[:base] << "ارتباط با اینستاگرام قطع شده‌است. دوباره وارد شوید"
      elsif e.message.include? "invalid media id"
        mark_to_be_checked
        self.errors[:base] << "این کمپین دیگر موجود نیست"
      else
        self.errors[:base] << e.message   # controller provides this error as the reason to the request
      end
      return false
    rescue StandardError => e
      self.errors[:base] << e.message   # controller provides this error as the reason to the request
      return false
    end
  end

  # Performs the action of putting a like on the campaign
  # It doesn't do any kind of validations.
  def like(user)
    begin
      # makes sure that the campaign just get liked once by the same user
      return true if self.liked_by? user

      if self.liking_users << user
        self.total_likes += 1
        self.like_credit_operations user  # Performs all the liking-related credit operations
        self.available = false if self.budget < self.price.campaign_value
        self.save
        user.save
        if self.save && user.save
          return true
        else
          return false
        end
      else
        return false
      end
    rescue StandardError
      return false
    end
  end

  # Performs respective credit actions for liking a campaign
  def like_credit_operations(user)
    case self.payment_type  # whether its payment_type is like_getter or money_getter
    when "like_getter"
      user.like_credit += self.price.users_share   # adds like_credit based on the price's users_share
      self.budget -= self.price.campaign_value     # Decreases campaign budget by the price's campaign_value
    when "money_getter"
      user.coin_credit += self.price.users_share   # adds coin_credit based on the price's users_share
      self.budget -= self.price.campaign_value     # Decreases campaign budget by the price's campaign_value
    end
  end

  # Checks if the like actually exists
  def liked_by?(user)
    Like.exists?(campaign_id: self.id, user_id: user.id)
  end

  # All th validations that it has to check before
  # liking a campaign
  # It checks: campaign's availablity,
  #            campaign's verification,
  #            whether campaign has enough budget,
  #            duration between each like
  def validate_before_like(user)
    # checks if campaign is available
    unless self.available == true
      self.errors[:base] << "این کمپین به پایان رسیده‌است"
      return false
    end
    # checks if campaign is verified
    unless self.verified == true
      self.errors[:base] << "این کمپین به تایید مدیریت نرسیده‌است"
      return false
    end
    # checks if campaign does have enough budget
    unless self.price.campaign_value <= self.budget
      self.errors[:base] << "بودجه این کمپین به پایان رسیده‌است"
      return false
    end
    # checks the duration between each like
    if period_between(user)
      self.errors[:base] << "بین هر لایک باید چند ثانیه صبر کنید"
      return false
    end
    return true
  end

  # Checks if the duration between each like is valid
  def period_between(user)
    last_like = Like.where(user: user).last
    return false if last_like.nil?

    Time.now - last_like.created_at < self.waiting.period
  end

  private

  # Marks a campaign to be checked manually by admins
  # Specially regarding deleted source of the campaign case
  # Sets 'available' to false and 'verified' to nil.
  def mark_to_be_checked
    self.available = false
    self.verified = nil
    self.save
  end

end
