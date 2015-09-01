class AddVerifiedToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :verified, :boolean
  end
end
