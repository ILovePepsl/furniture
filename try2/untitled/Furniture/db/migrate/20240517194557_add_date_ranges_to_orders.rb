class AddDateRangesToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :user_start_date, :date
    add_column :orders, :user_end_date, :date
    add_column :orders, :manufacturer_start_date, :date
    add_column :orders, :manufacturer_end_date, :date
  end
end
