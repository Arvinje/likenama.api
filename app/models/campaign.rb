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
  validates :campaign_type, presence: true, inclusion: { in: proc { OperatorRegistry.available_types }, message: "is not a valid campaign_type" }
  validates :payment_type, presence: true, inclusion: { in: ['money_getter', 'like_getter'], message: "is not a valid payment_type" }
  validates :budget, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :owner, presence: true

  validate  { |campaign| CampaignValidator.new(campaign).validate }

  scope :available, -> { where status: 'available' }
  scope :ended, -> { where status: 'ended' }
  scope :pending, -> { where pending: 'pending' }
  scope :rejected, -> { where status: 'rejected' }
  scope :check_needed, -> { where status: 'check_needed' }

  enum status: { pending: 'pending', available: 'available', rejected: 'rejected',
                 ended: 'ended', check_needed: 'check_needed' }

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
    self.waiting = Waiting.where(campaign_type: campaign_type, payment_type: payment_type).last
  end

  # Sets the day's campaign price based on campaign/payment type.
  def set_price
    self.price = Price.where(campaign_type: campaign_type, payment_type: payment_type).last
  end

  def detail
    send("#{self.campaign_type}_detail")
  end

  # Verifies a pending campaign and makes it available.
  def verify!
    available! if pending?
  end

  # Rejects a pending or currently available campaign.
  # Sets the status field to `rejected` and
  # returns the budget back to the owner's account.
  def reject!
    return unless pending? || available?
    begin
      # based on the campaign_type returns the budget back to the account
      ActiveRecord::Base.transaction do
        if payment_type == "money_getter"
          owner.coin_credit += budget
        else
          owner.like_credit += budget
        end
        rejected!
        owner.save!
      end
    rescue
      # Exception logging!
    end
  end

  def self.for_user(user) # Returns available campaigns that are not liked by the user
    self.available.where("id not in (select campaign_id from likes where user_id = ? and status = 'available')", user.id).first
  end

  # Checks if user has already liked the campaign.
  #
  # @return [Boolean] true if user liked the campaign, false otherwise.
  def liked_by? user
    Like.exists?(campaign: self, user: user)
  end

end
