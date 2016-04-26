class CreateCampaigns < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE TYPE campaign_status AS ENUM ('pending', 'available', 'rejected', 'ended', 'check_needed');
        SQL
      end
      dir.down do
        execute <<-SQL
          DROP TYPE campaign_status;
        SQL
      end
    end

    create_table :campaigns do |t|
      t.references       :campaign_class
      t.string           :type
      t.references       :owner
      t.string           :target, default: ""
      t.column           :status, :campaign_status
      t.integer          :budget
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
