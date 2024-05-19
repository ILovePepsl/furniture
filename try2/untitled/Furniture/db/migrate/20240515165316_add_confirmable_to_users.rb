class AddConfirmableToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string # Only if using reconfirmable

    add_index :users, :confirmation_token, unique: true

    # Uncomment below if timestamps were not included in your original model.
    # add_timestamps :users, default: -> { 'CURRENT_TIMESTAMP' }
    # change_column_default :users, :created_at, from: nil, to: -> { 'CURRENT_TIMESTAMP' }
    # change_column_default :users, :updated_at, from: nil, to: -> { 'CURRENT_TIMESTAMP' }
  end
end
