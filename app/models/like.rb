class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign

  validates :user, presence: true
  validates :campaign, presence: true
end