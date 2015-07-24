class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :campaign, index: true, foreign_key: true
      t.boolean :paid, default: false

      t.timestamps null: false
    end
  end
end
