ActiveAdmin.setup do |config|
  config.site_title = "Furniture"

  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_admin_user

  config.logout_link_path = :destroy_user_session_path
  config.logout_link_method = :delete

  config.root_to = 'dashboard#index'
  config.comments = false
  config.batch_actions = true
  config.localize_format = :long
  config.filters = true
  config.default_per_page = 30
  config.max_per_page = 10_000
  config.download_links = [:csv, :xml, :json]
end
