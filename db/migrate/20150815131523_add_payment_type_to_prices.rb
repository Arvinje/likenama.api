class AddPaymentTypeToPrices < ActiveRecord::Migration
  def up
    add_column :prices, :payment_type, :payment_type, index: true
  end

  def down
    remove_column :prices, :payment_type
  end
end
