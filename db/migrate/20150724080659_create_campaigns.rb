class CreateCampaigns < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE TYPE payment_type AS ENUM ('like_getter', 'money_getter');
          CREATE TYPE campaign_status AS ENUM ('pending', 'available', 'rejected', 'ended', 'check_needed');
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP TYPE payment_type;
          DROP TYPE campaign_status;
        SQL
      end
    end

    create_table :campaigns do |t|
      t.string           :target, default: ""
      t.string           :type
      t.column           :status, :campaign_status
      t.integer          :budget
      t.column           :payment_type, :payment_type
      t.references       :owner
      t.references       :waiting
      t.references       :price
      t.text             :description, default: ""
      t.string           :phone, default: ""
      t.string           :website, default: ""
      t.text             :address, default: ""
      t.string           :photo_url, default: ""
      t.integer          :total_likes, default: 0

      t.timestamps null: false
    end
  end
end
