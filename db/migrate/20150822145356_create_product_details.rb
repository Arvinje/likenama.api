class CreateProductDetails < ActiveRecord::Migration
  def change
    create_table :product_details do |t|
      t.text        :code, default: ''
      t.text        :description, default: ''
      t.references  :product
      t.timestamps null: false
    end
  end
end
