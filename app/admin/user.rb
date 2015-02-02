ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :organization_id

  index do
    selectable_column
    id_column
    column :email
    column :organization
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :organization
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :organization
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
