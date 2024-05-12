ActiveAdmin.register Product do
  permit_params :name, :price, :description, :image # параметры, которые можно редактировать

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :description
    actions
  end

  filter :name
  filter :price

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :price
      f.input :description
      f.input :image, as: :file
    end
    f.actions
  end
end
