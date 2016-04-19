class AddCampaignClassIdToCampaigns < ActiveRecord::Migration
  def change
    add_reference :campaigns, :campaign_class, index: true, foreign_key: true
  end
end
