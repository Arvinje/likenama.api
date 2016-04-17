class Campaign < ActiveRecord::Base
  include PublicActivity::Common
  attr_accessor :target_url

  before_create :set_price
  before_create :set_waiting

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  belongs_to :owner, class_name: 'User'
  belongs_to :price
  belongs_to :waiting
  has_many   :reports, dependent: :destroy
  has_many   :reporters, through: :reports, source: :user

  validates :payment_type, presence: true, inclusion: { in: ['money_getter', 'like_getter'] }
  validates :budget, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
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
    self.waiting = Waiting.where(campaign_type: type, payment_type: payment_type).last
  end

  # Sets the day's campaign price based on campaign/payment type.
  def set_price
    self.price = Price.where(campaign_type: type, payment_type: payment_type).last
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
