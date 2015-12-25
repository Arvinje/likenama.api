class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string      :title
      t.text        :description
      t.integer     :price
      t.boolean     :available, default: true
      t.references  :product_type

      t.timestamps null: false
    end
  end
end
