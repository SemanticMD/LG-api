class AddUuidToCvRequest < ActiveRecord::Migration
  def change
    add_column :cv_requests, :server_uuid, :string
  end
end
