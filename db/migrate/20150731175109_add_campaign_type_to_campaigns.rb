class AddCampaignTypeToCampaigns < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE campaign_type AS ENUM ('instagram', 'web');
    SQL

    add_column :campaigns, :campaign_type, :campaign_type, index: true
  end

  def down
    remove_column :campaigns, :campaign_type

    execute <<-SQL
      DROP TYPE campaign_type;
    SQL
  end
end
