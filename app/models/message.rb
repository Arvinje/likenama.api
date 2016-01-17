class Message < ActiveRecord::Base
  include PublicActivity::Common
  
  belongs_to :user

  validates :content, presence: true
  validates :user, presence: true

  enum read: { read: true, unread: false }
end
