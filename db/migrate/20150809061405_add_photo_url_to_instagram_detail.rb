class AddPhotoUrlToInstagramDetail < ActiveRecord::Migration
  def change
    add_column :instagram_details, :photo_url, :string
  end
end
