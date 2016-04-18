class AddAttachmentCoverToCampaigns < ActiveRecord::Migration
  def self.up
    change_table :campaigns do |t|
      t.attachment :cover
    end
  end

  def self.down
    remove_attachment :campaigns, :cover
  end
end
