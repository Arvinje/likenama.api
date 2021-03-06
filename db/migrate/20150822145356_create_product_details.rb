class CreateProductDetails < ActiveRecord::Migration
  def change
    create_table :product_details do |t|
      t.text        :code, default: ''
      t.boolean     :available, default: true
      t.references  :product
      t.references  :user
      t.timestamps null: false
    end
  end
end
