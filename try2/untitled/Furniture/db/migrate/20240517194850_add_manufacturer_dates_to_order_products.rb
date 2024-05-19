class AddManufacturerDatesToOrderProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :order_products, :manufacturer_start_date, :date
    add_column :order_products, :manufacturer_end_date, :date
  end
end
