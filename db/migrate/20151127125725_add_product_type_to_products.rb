class AddProductTypeToProducts < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE product_type AS ENUM ('mobiletopup');
    SQL

    add_column :products, :product_type, :product_type, index: true
  end

  def down
    remove_column :products, :product_type

    execute <<-SQL
      DROP TYPE product_type;
    SQL
  end
end
