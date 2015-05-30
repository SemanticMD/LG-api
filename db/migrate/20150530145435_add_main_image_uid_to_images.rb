class AddMainImageUidToImages < ActiveRecord::Migration
  def change
    add_column :images, :main_image_uid, :string
  end
end
