class AddAvailableToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :available, :boolean
  end
end
