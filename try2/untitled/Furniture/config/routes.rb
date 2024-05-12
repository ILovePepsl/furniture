# config/routes.rb
Rails.application.routes.draw do
  # Локализация URL с использованием динамического параметра locale
  scope "(:locale)", locale: /en|ru/ do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

    resources :orders

    resources :carts do
      member do
        post :add_product
        delete :remove_product
        patch :update_quantity
      end
    end

    resources :products

    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

    # Маршрут для проверки состояния приложения
    get 'up' => 'rails/health#show', as: :rails_health_check



    # Корневой маршрут приложения
    root 'products#index'
  end
end
