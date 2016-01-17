class Report < ActiveRecord::Base
  include PublicActivity::Common
  
  belongs_to :user
  belongs_to :campaign

  enum checked: { check: true, uncheck: false }
end
