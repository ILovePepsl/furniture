class Collection < ApplicationRecord
  belongs_to :user
  has_many :collection_products, dependent: :destroy
  has_many :products, through: :collection_products

  validates :name, presence: true

  def average_rating
    rated_products = products.joins(:reviews).distinct #находим все продукты кол. с отзываами
    return 0 if rated_products.empty? #уходим если нет прод. с отзывами

    total_rating = rated_products.sum { |product| product.reviews.average(:rating).to_f } #сумма
    total_rating / rated_products.size #средний рейт
  end

  def total_price
    products.sum(:price)
  end

end
