# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products, dependent: :destroy  # Добавьте dependent: :destroy
  has_many :products, through: :order_products

  def self.ransackable_attributes(auth_object = nil)
    %w[address created_at first_name id last_name phone status total_price updated_at user_id]
  end
end
