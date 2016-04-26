class CreateCampaignClasses < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE TYPE payment_type AS ENUM ('like', 'coin');
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP TYPE payment_type;
        SQL
      end
    end

    create_table :campaign_classes do |t|
      t.string  :campaign_type
      t.column  :payment_type, :payment_type
      t.boolean :status, default: true, null: false
      t.integer :campaign_value, default: 0
      t.integer :coin_user_share, default: 0
      t.integer :like_user_share, default: 0
      t.integer :waiting, default: 0

      t.timestamps null: false
    end
  end
end
