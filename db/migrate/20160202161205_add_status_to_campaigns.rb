class AddStatusToCampaigns < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE campaign_status AS ENUM ('pending', 'available', 'rejected', 'ended', 'check_needed');
    SQL

    add_column :campaigns, :status, :campaign_status, index: true
  end

  def down
    remove_column :campaigns, :status

    execute <<-SQL
      DROP TYPE campaign_status;
    SQL
  end
end
