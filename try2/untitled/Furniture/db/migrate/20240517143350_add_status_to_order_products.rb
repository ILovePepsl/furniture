# db/migrate/[timestamp]_add_status_to_order_products.rb
class AddStatusToOrderProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :order_products, :status, :string, default: 'In processing'
  end
end
