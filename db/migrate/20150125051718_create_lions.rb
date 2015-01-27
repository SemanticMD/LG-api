class CreateLions < ActiveRecord::Migration
  def change
    create_table :lions do |t|
      t.string :name, null: false, unique: true
      t.integer :organization_id
      t.string :gender
      t.string :age

      t.timestamps null: false

      t.index :name, :unique => true
    end
  end
end
