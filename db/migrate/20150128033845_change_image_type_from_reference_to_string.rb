class ChangeImageTypeFromReferenceToString < ActiveRecord::Migration
  def up
    rename_column :images, :image_type_id, :image_type
    change_column :images, :image_type, :string
  end

  def down
    rename_column :images, :image_type, :image_type_id
    change_column :images, :image_type_id, :integer
  end
end
