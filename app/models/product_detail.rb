class ProductDetail < ActiveRecord::Base
  belongs_to  :product
  has_many    :purchases
  has_many    :buyers, through: :purchases, source: :user

  validates :code, presence: true

  scope :available, -> { where available: true }
  scope :sold, -> { where available: false }
end
