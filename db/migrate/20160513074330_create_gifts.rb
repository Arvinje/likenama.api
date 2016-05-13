class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string     :email, null: false, index: true, foreign_key: true
      t.integer    :coin_credit, default: 0
      t.integer    :like_credit, default: 0
      t.daterange  :duration, null: false
      t.boolean    :status, default: false

      t.timestamps null: false
    end
  end
end
