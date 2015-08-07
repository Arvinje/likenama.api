class AddPaymentTypeToCampaigns < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE payment_type AS ENUM ('like_getter', 'money_getter');
    SQL

    add_column :campaigns, :payment_type, :payment_type, index: true
  end

  def down
    remove_column :campaigns, :payment_type

    execute <<-SQL
      DROP TYPE payment_type;
    SQL
  end
end
