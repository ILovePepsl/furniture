class AddCurrencyToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :currency, :string, default: 'UAH'
  end
end