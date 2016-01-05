class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, index: true, foreign_key: true
      t.string :email, default: ''
      t.string :name, default: ''
      t.text :content

      t.timestamps null: false
    end
  end
end
