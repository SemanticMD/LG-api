class DropImageTypes < ActiveRecord::Migration
  def up
    drop_table :image_types
  end

  def down
    create_table :image_types do |t|
      t.string :name, null: false
      t.string :display_name, null: false
      t.timestamps null: false

      t.index :name, :unique => true
    end
  end
end
