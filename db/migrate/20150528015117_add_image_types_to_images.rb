class AddImageTypesToImages < ActiveRecord::Migration
  def change
    add_column :images, :full_image_uid, :string
    add_column :images, :thumbnail_image_uid, :string
  end
end
