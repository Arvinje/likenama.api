class AddNameToManagers < ActiveRecord::Migration
  def change
    add_column :managers, :name, :string, default: ''
  end
end
