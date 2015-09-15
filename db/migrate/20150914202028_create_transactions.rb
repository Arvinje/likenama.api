class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :id_get, default: ''
      t.string :trans_id, default: ''
      t.references :user
      t.references :bundle
      
      t.timestamps null: false
    end
  end
end
