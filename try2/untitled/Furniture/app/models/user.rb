class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :cart, dependent: :destroy
  has_many :orders

  after_create :create_cart_for_user

  def create_cart_for_user
    self.create_cart unless self.cart.present?
  end

  def admin?
    admin
  end
end
