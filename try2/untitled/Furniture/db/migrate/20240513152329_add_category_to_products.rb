class AddCategoryToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :category_id, :integer
    add_index :products, :category_id
  end
end
