class CreateKeyValues < ActiveRecord::Migration
  def change
    create_table :key_values do |t|
      t.string :key
      t.integer :value

      t.timestamps null: false
    end
    add_index :key_values, :key
  end
end
