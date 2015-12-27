class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign

  enum checked: { check: true, uncheck: false }
end
