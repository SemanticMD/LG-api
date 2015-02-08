class AddDeviseTrackableToUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      ## Trackable
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
    end
  end
end
