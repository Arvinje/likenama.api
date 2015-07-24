class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.integer :campaign_type, default: 0
      t.integer :like_value
      t.integer :total_likes, default: 0

      t.timestamps null: false
    end
  end
end
