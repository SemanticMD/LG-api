class CreateCvResults < ActiveRecord::Migration
  def change
    create_table :cv_results do |t|
      t.integer :cv_request_id, null: false
      t.integer :image_id, null: false
      t.float :match_probability, null: false

      t.timestamps null: false

      t.index [:cv_request_id]
      t.index [:image_id]
    end
  end
end
