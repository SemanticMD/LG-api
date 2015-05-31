class AddNotesToImageSets < ActiveRecord::Migration
  def change
    add_column :image_sets, :notes, :text
  end
end
