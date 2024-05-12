class Product < ApplicationRecord

  has_one_attached :image

  def self.ransackable_attributes(auth_object = nil)
    %w[name price description]
  end

  # Определяем, какие атрибуты могут использоваться для поиска
  def self.ransackable_attributes(auth_object = nil)
    %w[name price description]  # Список атрибутов, доступных для поиска
  end

  # Опционально, вы можете также определить, какие ассоциации разрешено использовать для поиска
  def self.ransackable_associations(auth_object = nil)
    []  # Здесь нет ассоциаций, но вы можете добавить если необходимо
  end
end
