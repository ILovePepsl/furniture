Rails.application.routes.draw do
  scope "(:locale)", locale: /en|uk/ do
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

    resources :products do
      resources :reviews, only: [:create, :destroy]
    end

    resources :categories, only: [:show]

    resources :collections do
      member do
        post 'add_all_to_cart'
      end
      resources :products, only: [:create, :destroy], controller: 'collection_products'
    end

    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations'
    }

    devise_scope :user do
      get 'manufacturers/sign_up', to: 'manufacturers/registrations#new', as: :new_manufacturer_registration
      post 'manufacturers', to: 'manufacturers/registrations#create', as: :manufacturer_registration
    end

    resource :profile, only: [:show, :edit, :update]
    resources :users, only: [:show] do
      member do
        get :orders, to: 'manufacturers/orders#user_orders'
      end
      get 'rss', to: 'products#rss', as: 'rss_feed'
      resources :subscriptions, only: [:create, :destroy]
    end

    namespace :manufacturers do
      resources :orders, only: [:index, :show, :update]
      get 'order_products', to: 'orders#order_products', as: 'order_products'
    end

    resources :manufacturers, only: [] do
      resources :products, only: [:index], controller: 'manufacturers/products'
    end

    resource :wishlist, only: [:show] do
      post 'add_product', to: 'wishlists#add_product'
      delete 'remove_product', to: 'wishlists#remove_product'
    end

    resources :collections do
      post 'add_all_to_cart', on: :member
      resources :products, only: [:create, :destroy], controller: 'collection_products'
    end

    root 'products#index'
  end
end
