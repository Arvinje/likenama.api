class CreateInstagramDetails < ActiveRecord::Migration
  def change
    create_table :instagram_details do |t|
      t.string :short_code, default: ""
      t.text :description, default: ""
      t.string :phone, default: ""
      t.string :website, default: ""
      t.text :address, default: ""
      t.references :campaign, index: true

      t.timestamps null: false
    end
  end
end
