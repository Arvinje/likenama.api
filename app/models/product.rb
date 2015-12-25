class Product < ActiveRecord::Base
  include PublicActivity::Common

  belongs_to :product_type
  has_many :details, class_name: 'ProductDetail', dependent: :destroy
  has_many :buyers, through: :details, source: :user

  validates :title, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :product_type, presence: true

  accepts_nested_attributes_for :details

  scope :available, -> { where available: true }
end
