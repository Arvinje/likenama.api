class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.integer :type
      t.integer :like_value
      t.integer :total_likes, default: 0

      t.timestamps null: false
    end
  end
end
