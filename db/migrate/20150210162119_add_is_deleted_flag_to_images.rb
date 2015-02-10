class AddIsDeletedFlagToImages < ActiveRecord::Migration
  def change
    add_column :images, :is_deleted, :boolean, default: false
    add_index  :images, [:image_set_id, :is_deleted], where: 'is_deleted IS NOT TRUE'
  end
end
