class Product < ActiveRecord::Base
  has_many :purchases
  has_many :buyers, through: :purchases, source: :user

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { only_integer: true }
  validates :details, presence: true
end
