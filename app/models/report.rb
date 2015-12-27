class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign

  validates :checked, inclusion: { in: [true, false] }
end
