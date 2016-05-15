class Message < ActiveRecord::Base
  include PublicActivity::Common

  belongs_to :user

  validates :email, presence: true, email: { strict_mode: true }
  validates :content, presence: true, length: { maximum: 500 }
  validates :user, presence: true

  enum read: { read: true, unread: false }
end
