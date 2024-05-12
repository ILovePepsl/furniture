# db/migrate/XXXXXXXXXXXXXX_create_carts_for_existing_users.rb
class CreateCartsForExistingUsers < ActiveRecord::Migration[7.1]
  def up
    User.find_each do |user|
      user.create_cart unless user.cart
    end
  end

  def down
  end
end
