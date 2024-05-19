ActiveAdmin.register User do
  permit_params :email, :name, :role

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :role
    actions
  end

  filter :name
  filter :email
  filter :role, as: :select, collection: User.roles.keys

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :role, as: :select, collection: User.roles.keys.map { |role| [role.titleize, role] }
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :role
      row :created_at
      row :updated_at
    end
  end
end
