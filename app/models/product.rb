class Product < ActiveRecord::Base
  has_many :details, class_name: 'ProductDetail', dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { only_integer: true }
  validates :product_type, presence: true, inclusion: { in: ['mobiletopup'], message: "is not a valid product_type" }

  accepts_nested_attributes_for :details

  scope :available, -> { where available: true }
end
