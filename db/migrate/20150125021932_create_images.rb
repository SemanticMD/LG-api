class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :image_type_id
      t.integer :image_set_id, :null => false
      t.boolean :is_public, default: false
      t.string :url, :null => false

      t.timestamps null: false
    end
  end
end
