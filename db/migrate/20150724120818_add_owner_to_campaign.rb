class AddOwnerToCampaign < ActiveRecord::Migration
  def change
    add_reference :campaigns, :owner, index: true
  end
end
