class Product < ApplicationRecord

  has_one_attached :image

  def self.ransackable_attributes(auth_object = nil)
    %w[name price description]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name price description]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
