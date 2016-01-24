class Campaign < ActiveRecord::Base
  include PublicActivity::Common

  before_save :set_price
  before_save :set_waiting

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  belongs_to :owner, class_name: 'User'
  has_one :instagram_detail, inverse_of: :campaign, dependent: :destroy
  belongs_to :price
  belongs_to :waiting
  has_many   :reports, dependent: :destroy
  has_many   :reporters, through: :reports, source: :user

  # Edit these two when adding new types, also add new postgres enums when needed
  validates :campaign_type, presence: true, inclusion: { in: ['instagram'], message: "is not a valid campaign_type" }
  validates :payment_type, presence: true, inclusion: { in: ['money_getter', 'like_getter'], message: "is not a valid payment_type" }
  validates :budget, presence: true, numericality: { only_integer: true }
  validates :owner, presence: true

  validate  :must_have_one_association
  validate  { |campaign| CampaignValidator.new(campaign).validate }

  accepts_nested_attributes_for :instagram_detail, update_only: true, reject_if: :instagram_only

  scope :available, -> { where available: true }
  scope :finished, -> { where available: false }
  scope :pending, -> { where verified: nil }
  scope :rejected, -> { where verified: false }

  # Based on the passed status returns the respective
  # scoped relation.
  def self.with_status(status)
    {
      available: self.available,
      finished: self.finished,
      pending: self.pending,
      rejected: self.rejected
    }.fetch(status.to_sym) { self }
  end

  # Sets the day's campaign waiting based on campaign/payment type.
  def set_waiting
    self.waiting = Waiting.where(campaign_type: self.campaign_type, payment_type: self.payment_type).last
  end

  # Sets the day's campaign price based on campaign/payment type.
  def set_price
    self.price = Price.where(campaign_type: self.campaign_type, payment_type: self.payment_type).last
  end

  def detail
    self.send("#{self.campaign_type}_detail")
  end

  def status
    case self.verified
    when nil
      "درحال بررسی"
    when true
      case self.available
      when nil
        "نمایش داده‌نشده"
      when true
        "درحال نمایش"
      when false
        "به‌پایان رسیده"
      end
    when false
      "رد شده"
    end
  end

  # Verifies a campaign and makes it available.
  def verify!
    if self.verified.nil?
      self.verified = true
      self.available = true
      self.save
    else
      false
    end
  end

  # Rejects a campaign
  # Sets the verified flag to false and available to nil
  # returns the budget back to the owner's account
  def reject!
    if self.verified.nil? || self.verified == true
      owner = self.owner
      self.verified = false
      self.available = nil
      # based on the campaign_type returns the budget back to the account
      if self.payment_type == "money_getter"
        owner.coin_credit += self.budget
      else
        owner.like_credit += self.budget
      end
      owner.save && self.save
    else
      false
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


  # Checks if user has already liked the campaign.
  #
  # @return [Boolean] true if user liked the campaign, false otherwise.
  def liked_by? user
    Like.exists?(campaign: self, user: user)
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
