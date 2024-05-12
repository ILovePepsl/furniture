# app/models/cart.rb
class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_products
  has_many :products, through: :cart_products

  # Добавьте любую дополнительную логику, которая может понадобиться для управления корзиной
end
