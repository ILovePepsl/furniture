class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :manufacturer, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
