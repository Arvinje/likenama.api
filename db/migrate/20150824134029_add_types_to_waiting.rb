class AddTypesToWaiting < ActiveRecord::Migration
  def up
    add_column :waitings, :campaign_type, :campaign_type, index: true
    add_column :waitings, :payment_type, :payment_type, index: true
  end

  def down
    remove_column :waitings, :campaign_type
    remove_column :waitings, :payment_type
  end
end
