class BundlePurchase < ActiveRecord::Base

  belongs_to :user
  belongs_to :bundle

  validates :user, presence: true
  validates :bundle, presence: true

end
