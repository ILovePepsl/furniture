class Product < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :manufacturer, class_name: 'User', foreign_key: 'manufacturer_id', optional: true
  has_many :reviews, dependent: :destroy
  has_one_attached :image
  has_many :collection_products
  has_many :collections, through: :collection_products

  def self.ransackable_attributes(auth_object = nil)
    %w[name price description]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category manufacturer reviews]
  end

  def average_rating
    reviews.average(:rating).to_f.round(2)
  end

  def self.sort_by_average_rating(order)
    products_with_reviews = all.select { |product| product.reviews.exists? }
    products_without_reviews = all.reject { |product| product.reviews.exists? }

    sorted_products = products_with_reviews.sort_by(&:average_rating)
    sorted_products.reverse! if order == 'desc'

    sorted_products.concat(products_without_reviews)
  end
end
