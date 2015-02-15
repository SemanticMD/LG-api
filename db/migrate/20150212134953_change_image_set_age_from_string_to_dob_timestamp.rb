class ChangeImageSetAgeFromStringToDobTimestamp < ActiveRecord::Migration
  def change
    remove_column :image_sets, :age, :string
    add_column :image_sets, :date_of_birth, :timestamp
  end
end
