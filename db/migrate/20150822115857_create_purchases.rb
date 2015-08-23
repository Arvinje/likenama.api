class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references  :user
      t.references  :product_detail

      t.timestamps null: false
    end
  end
end
