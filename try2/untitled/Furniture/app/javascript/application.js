// app/javascript/application.js
import "@hotwired/turbo-rails"
import "@rails/ujs"  // Добавить эту строку
Rails.start()       // Инициализация @rails/ujs
import "controllers"
