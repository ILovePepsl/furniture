# app/admin/orders.rb
ActiveAdmin.register Order do
  permit_params :first_name, :last_name, :phone, :address, :total_price, :status

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :phone
    column :address
    column :total_price
    column :status
    column :created_at
    actions
  end

  filter :first_name
  filter :last_name
  filter :status
  filter :total_price
  filter :created_at

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :phone
      f.input :address
      f.input :total_price
      f.input :status, as: :select, collection: ['In processing', 'Completed', 'Cancelled']
    end
    f.actions
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :phone
      row :address
      row :total_price
      row :status
      row :created_at
      row :updated_at
    end
    panel "Products in this Order" do
      table_for order.order_products.includes(:product) do
        column "Product" do |order_product|
          link_to order_product.product.name, admin_product_path(order_product.product)
        end
        column :quantity
      end
    end
  end
end
