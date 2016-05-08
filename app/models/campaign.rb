class Campaign < ActiveRecord::Base
  include PublicActivity::Common
  attr_accessor :target_url, :payment_type, :waiting

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  belongs_to :owner, class_name: 'User'
  belongs_to :campaign_class
  has_many   :reports, dependent: :destroy
  has_many   :reporters, through: :reports, source: :user

  validates :budget, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :owner, presence: true
  validates :campaign_class, presence: true

  validate  { |campaign| CampaignValidator.new(campaign).validate }

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

  # Creates a hash full of fields and their states
  # based on the waiting state.
  #
  # @return [Hash]
  def self.fields(waiting=nil)
    Hash.new.tap do |fields|
      fields[:description] = waiting ? true : false
      fields[:phone] = waiting ? true : false
      fields[:website] = waiting ? true : false
      fields[:address] = waiting ? true : false
    end
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
        if payment_type == "coin"
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

  # Returns available campaigns that are not liked by the user
  #
  # @return [Campaign] the next campaign
  def self.for_user(user)
    self.available.where("id not in (select campaign_id from likes where user_id = ? and status = 'available')", user.id).first
  end

  # Checks if user has already liked the campaign.
  #
  # @return [Boolean] true if user liked the campaign, false otherwise.
  def liked_by? user
    Like.exists?(campaign: self, user: user)
  end

  def payment_type
    @payment_type || campaign_class.payment_type
  end

  def campaign_type
    type.chomp("Campaign").underscore
  end

  def waiting
    return campaign_class.waiting if @waiting.nil?
    @waiting
  end

end
