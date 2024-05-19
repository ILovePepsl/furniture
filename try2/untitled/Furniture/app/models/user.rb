class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable


  has_one :cart, dependent: :destroy
  has_many :orders
  has_one_attached :avatar
  has_many :products, foreign_key: 'manufacturer_id'
  has_one :wishlist, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :reviewed_products, through: :reviews, source: :product
  has_many :subscriptions
  has_many :subscribed_manufacturers, through: :subscriptions, source: :manufacturer
  has_many :subscriber_subscriptions, class_name: 'Subscription', foreign_key: 'manufacturer_id'
  has_many :subscribers, through: :subscriber_subscriptions, source: :user
  has_many :collections, dependent: :destroy

  enum role: { admin: 'admin', customer: 'customer', manufacturer: 'manufacturer' }

  after_create :create_cart_and_wishlist_for_user

  validates :currency, inclusion: { in: %w[UAH USD EUR], message: "%{value} is not a valid currency" }

  def create_cart_and_wishlist_for_user
    create_cart unless cart.present?
    create_wishlist unless wishlist.present?
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id name email role created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def admin?
    role == 'admin'
  end

  def manufacturer?
    role == 'manufacturer'
  end

  def after_confirmation
    if self.unconfirmed_email.present? && self.role == 'manufacturer'
      self.update(role: 'manufacturer')
    end
  end
end
