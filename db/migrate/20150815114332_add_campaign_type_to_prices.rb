class AddCampaignTypeToPrices < ActiveRecord::Migration
  def up
    add_column :prices, :campaign_type, :campaign_type, index: true
  end

  def down
    remove_column :prices, :campaign_type
  end
end