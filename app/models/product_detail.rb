class ProductDetail < ActiveRecord::Base
  include PublicActivity::Common
  after_save :check_products_availability

  belongs_to  :product
  belongs_to  :user

  validates :code, presence: true

  scope :available, -> { where available: true }
  scope :sold, -> { where available: false }

  # If all of the product's details get bought,
  # it marks the product as unavailable.
  # And if the unavailable product receives a new available detail,
  # it marks the product as available.
  # Test: user_spec #buy
  def check_products_availability
    if self.available && !self.product.available
      self.product.available = true
      self.product.save
    elsif !self.available && self.product.details.available.empty?
      self.product.available = false
      self.product.save
    end
  end

end
