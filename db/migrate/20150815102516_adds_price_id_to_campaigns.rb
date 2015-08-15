class AddsPriceIdToCampaigns < ActiveRecord::Migration
  def change
    add_reference :campaigns, :price, index: true, foreign_key: true
  end
end
