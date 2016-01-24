class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign, counter_cache: :total_likes

  validates :user, presence: true
  validates :campaign, presence: true
end
