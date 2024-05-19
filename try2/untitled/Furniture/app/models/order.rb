class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  validates :user_start_date, :user_end_date, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[address created_at first_name id last_name phone status total_price updated_at user_id user_start_date user_end_date manufacturer_start_date manufacturer_end_date]
  end
end
