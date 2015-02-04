class AddPrimaryImageSetToLion < ActiveRecord::Migration
  def change
    add_column :lions, :primary_image_set_id, :integer
  end
end
