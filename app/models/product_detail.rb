class ProductDetail < ActiveRecord::Base
  include PublicActivity::Common

  belongs_to  :product
  belongs_to  :user

  validates :code, presence: true

  scope :available, -> { where available: true }
  scope :sold, -> { where available: false }
end
