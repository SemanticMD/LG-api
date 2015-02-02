class AllowNullLionIdOnImageSets < ActiveRecord::Migration
  def change
    change_column :image_sets, :lion_id, :integer, :null => true
  end
end
