class AddBudgetsToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :coin_budget, :integer
    add_column :campaigns, :like_budget, :integer
  end
end
