# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :cart, dependent: :destroy
  has_many :orders  # Добавить эту строку для связи пользователя с заказами

  after_create :create_cart_for_user

  def create_cart_for_user
    self.create_cart unless self.cart.present?
  end

  def admin?
    admin
  end
end
