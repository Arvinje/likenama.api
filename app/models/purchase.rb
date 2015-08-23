class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :product_detail

  validates :user_id, presence: true
  validates :product_detail_id, presence: true
end
