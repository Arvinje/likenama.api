class Gift < ActiveRecord::Base

  belongs_to :user, foreign_key: :email, primary_key: :email

  validates :email, presence: true, email: { strict_mode: true }
  validates :coin_credit, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :like_credit, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :duration, presence: true

  enum status: { redeemed: true, available: false }

  scope :active, -> { Gift.available.where("duration @> ?::date", Date.today) }

end
