class AdminUser < ApplicationRecord
  # Добавление Devise для аутентификации
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Определяем атрибуты, которые могут быть использованы для поиска
  def self.ransackable_attributes(auth_object = nil)
    %w[email created_at updated_at] # Включаем только безопасные атрибуты
  end

  # Если есть ассоциации, которые разрешено искать
  def self.ransackable_associations(auth_object = nil)
    []
  end
end
