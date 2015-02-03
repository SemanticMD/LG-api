class RemoveImageSetIdConstraint < ActiveRecord::Migration
  def change
    change_column_null :images, :image_set_id, true
  end
end
