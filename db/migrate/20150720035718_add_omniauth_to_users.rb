class AddOmniauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string, default: ""
    add_column :users, :omni_id, :string, default: ""
    add_index :users, [:provider, :omni_id]
  end
end
