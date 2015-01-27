class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.integer :organization_id

      t.timestamps null: false
    end
  end
end
