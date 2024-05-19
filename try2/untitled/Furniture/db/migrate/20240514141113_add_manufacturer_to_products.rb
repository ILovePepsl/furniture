class AddManufacturerToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :manufacturer_id, :integer
    add_index :products, :manufacturer_id
  end
end
