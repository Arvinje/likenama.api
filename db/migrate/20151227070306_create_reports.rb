class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.boolean :checked, default: false
      t.references :user, index: true, foreign_key: true
      t.references :campaign, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
