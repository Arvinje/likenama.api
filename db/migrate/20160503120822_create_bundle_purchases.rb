class CreateBundlePurchases < ActiveRecord::Migration
  def change
    create_table :bundle_purchases do |t|
      t.references :user, index: true, foreign_key: true
      t.references :bundle, index: true, foreign_key: true
      t.string :bazaar_purhcase_token, index: true

      t.timestamps null: false
    end
  end
end
