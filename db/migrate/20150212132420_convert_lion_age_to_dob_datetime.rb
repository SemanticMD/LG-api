class ConvertLionAgeToDobDatetime < ActiveRecord::Migration
  def change
    remove_column :lions, :age, :integer
    add_column :lions, :date_of_birth, :timestamp
  end
end
