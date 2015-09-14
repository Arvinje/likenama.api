class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.integer :total_likes, default: 0
      t.references :waiting

      t.timestamps null: false
    end
  end
end
