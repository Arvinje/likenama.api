class CreateWaitings < ActiveRecord::Migration
  def change
    create_table :waitings do |t|
      t.integer :period, default: 0

      t.timestamps null: false
    end
  end
end
