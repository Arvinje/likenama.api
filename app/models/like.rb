class Like < ActiveRecord::Base
  enum payment_status: { not_paid: 0, paid: 1 }

  belongs_to :user
  belongs_to :campaign

  validates :user, presence: true
  validates :campaign, presence: true
end
