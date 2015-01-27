class CreateImageTypes < ActiveRecord::Migration
  def change
    create_table :image_types do |t|
      t.string :name, null: false
      t.string :display_name, null: false
      t.timestamps null: false

      t.index :name, :unique => true
    end

    ['CV', 'Whisker', 'Main ID', 'Full Body'].each do |image_type|
      ImageType.create(:name => image_type.downcase.gsub(" ", "-"),
                       :display_name => image_type)
    end
  end
end
