class CreateImageSets < ActiveRecord::Migration
  def change
    create_table :image_sets do |t|
      t.integer :lion_id, :null => false
      t.integer :main_image_id

      t.integer :uploading_organization_id, :null => false
      t.integer :uploading_user_id, :null => false

      t.integer :owner_organization_id
      t.boolean :is_verified, :null => false, :default => false

      t.decimal :latitude, :decimal, {:precision => 10, :scale => 6}
      t.decimal :longitude, :decimal, {:precision => 10, :scale => 6}

      t.timestamp :photo_date

      t.string :gender
      t.string :age

      t.boolean :is_primary, :default => false

      t.timestamps null: false
    end
  end
end
