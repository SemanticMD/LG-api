class CreateCvRequests < ActiveRecord::Migration
  def change
    create_table :cv_requests do |t|
      t.integer :uploading_organization_id, null: false
      t.integer :image_set_id, null: false
      t.string :status

      t.timestamps null: false

      t.index [:uploading_organization_id, :status]
      t.index [:image_set_id]
    end
  end
end
