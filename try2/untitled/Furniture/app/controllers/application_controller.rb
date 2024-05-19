class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :set_exchange_rates

  helper_method :convert_price

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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :address, :website, :business_hours, :mobile, :role, :currency])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :address, :website, :business_hours, :mobile, :avatar, :role, :currency])
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def set_exchange_rates
    response = Net::HTTP.get(URI('https://api.privatbank.ua/p24api/pubinfo?exchange&json&coursid=11'))
    @exchange_rates = JSON.parse(response)
  end

  def convert_price(price_in_uah)
    return price_in_uah if current_user.currency == 'UAH'

    exchange_rate = @exchange_rates.find { |rate| rate['ccy'] == current_user.currency }
    return price_in_uah unless exchange_rate

    price_in_uah / exchange_rate['sale'].to_f
  end

  def currency_symbol(currency)
    case currency
    when 'USD'
      '$'
    when 'EUR'
      '€'
    when 'UAH'
      '₴'
    else
      currency
    end
  end

end
