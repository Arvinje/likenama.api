class Product < ActiveRecord::Base
  include PublicActivity::Common

  has_many :details, class_name: 'ProductDetail', dependent: :destroy
  has_many :buyers, through: :details, source: :user

  validates :title, presence: true
  validates :price, presence: true, numericality: { only_integer: true }
  validates :product_type, presence: true, inclusion: { in: ['mobiletopup'], message: "is not a valid product_type" }

  accepts_nested_attributes_for :details

  scope :available, -> { where available: true }
end
