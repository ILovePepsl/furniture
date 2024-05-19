# db/migrate/XXXXXX_add_wishlist_to_existing_users.rb
class AddWishlistToExistingUsers < ActiveRecord::Migration[7.1]
  def up
    User.find_each do |user|
      user.create_wishlist unless user.wishlist.present?
    end
  end

  def down
  end
end
