class Like < ActiveRecord::Base
  enum paid: { paid: true, not_paid: false }

  belongs_to :user
  belongs_to :campaign

  validates :user, presence: true
  validates :campaign, presence: true
end
