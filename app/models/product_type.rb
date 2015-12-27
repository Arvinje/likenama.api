class ProductType < ActiveRecord::Base
  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
