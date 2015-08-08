class AddCreditsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :like_credit, :integer, default: 0
    add_column :users, :coin_credit, :integer, default: 0
  end
end
