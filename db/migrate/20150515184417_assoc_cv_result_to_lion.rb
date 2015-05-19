class AssocCvResultToLion < ActiveRecord::Migration
  def change
    remove_column :cv_results, :image_id
    add_column :cv_results, :lion_id, :integer
    add_index :cv_results, [:lion_id]
  end
end
