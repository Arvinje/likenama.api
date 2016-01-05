class Message < ActiveRecord::Base
  belongs_to :user

  validates :content, presence: true
  validates :user, presence: true

  enum read: { read: true, unread: false }
end
