class CreateCampaignClasses < ActiveRecord::Migration
  def change
    create_table :campaign_classes do |t|
      t.string :campaign_type
      t.integer :coin_value, default: 0
      t.integer :coin_user_share, default: 0
      t.integer :like_value, default: 0
      t.integer :like_user_share, default: 0
      t.integer :waiting, default: 0

      t.timestamps null: false
    end
  end
end
