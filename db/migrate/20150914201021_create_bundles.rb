class CreateBundles < ActiveRecord::Migration
  def change
    create_table :bundles do |t|
      t.string  :bazaar_sku, index: true
      t.boolean :status, default: true
      t.integer :price, default: 0
      t.integer :coins, default: 0
      t.integer :free_coins, default: 0

      t.timestamps null: false
    end
  end
end
