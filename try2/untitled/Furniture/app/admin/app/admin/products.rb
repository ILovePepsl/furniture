ActiveAdmin.register Product do
  permit_params :name, :price, :description, :image, :category_id, :manufacturer_id

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :description
    column :category
    column :manufacturer
    actions
  end

  filter :name
  filter :price
  filter :category
  filter :manufacturer

  form do |f|
    f.inputs 'Product Details' do
      f.input :name
      f.input :price
      f.input :description
      f.input :image, as: :file
      f.input :category, as: :select, collection: Category.all.map { |c| [c.name, c.id] }
      f.input :manufacturer, as: :select, collection: User.where(role: 'manufacturer').map { |u| [u.email, u.id] }
    end
    f.actions
  end

  # Конфигурация экспорта
  csv do
    column :id
    column :name
    column :price
    column :description
    column(:category) { |product| product.category.name if product.category }
    column(:manufacturer) { |product| product.manufacturer.email if product.manufacturer }
    column :created_at
    column :updated_at
  end
end
