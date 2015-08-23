class Product < ActiveRecord::Base
  has_many :details, class_name: 'ProductDetail', dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { only_integer: true }

  accepts_nested_attributes_for :details
end
