class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :campaign_value, default: 0
      t.integer :users_share, default: 0

      t.timestamps null: false
    end
  end
end
