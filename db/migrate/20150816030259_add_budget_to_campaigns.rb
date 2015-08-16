class AddBudgetToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :budget, :integer
  end
end
