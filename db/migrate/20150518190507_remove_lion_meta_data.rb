class RemoveLionMetaData < ActiveRecord::Migration
  def change
    remove_column :lions, :date_of_birth
    remove_column :lions, :gender
  end
end
