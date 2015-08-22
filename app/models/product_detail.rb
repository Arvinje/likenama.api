class ProductDetail < ActiveRecord::Base
  belongs_to :product

  validates :code, presence: true
  validates :description, presence: true
end
