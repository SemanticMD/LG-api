class MetaDataColumns < ActiveRecord::Migration
  def change
    add_column :image_sets, :tags, :string, array: true

    add_index :image_sets, :tags, using: 'gin'
  end
end
