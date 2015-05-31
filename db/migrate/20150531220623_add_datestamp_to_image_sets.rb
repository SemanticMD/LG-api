class AddDatestampToImageSets < ActiveRecord::Migration
  def change
    add_column :image_sets, :date_stamp, :date
  end
end
