class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.admin?
      Rails.logger.info "Authentication failed: User is not an admin."
      redirect_to root_path, alert: "You are not authorized to access this page."
    else
      Rails.logger.info "Authentication successful: #{current_user.email}"
    end
  end


  def current_admin_user
    if current_user&.admin?
      Rails.logger.info "Current admin user: #{current_user.email}"
      current_user
    else
      Rails.logger.info "No admin user currently signed in."
      nil
    end
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
