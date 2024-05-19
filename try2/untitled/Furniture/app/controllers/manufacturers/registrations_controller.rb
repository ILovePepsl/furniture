class Manufacturers::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :validate_email_domain, only: [:create]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :address, :website, :business_hours, :mobile, :role])
  end

  def validate_email_domain
    unless params[:user][:email].ends_with?('@karazin.ua')
      flash[:alert] = "You must use an email with the domain @karazin.ua to register as a manufacturer."
      redirect_to new_manufacturer_registration_path and return
    end
  end

  def after_sign_up_path_for(resource)
    resource.update(role: 'manufacturer')
    super(resource)
  end
end
