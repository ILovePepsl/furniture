class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exchange_rates, only: [:show, :edit]

  def show
  end

  def edit
  end

  def update
    if current_user.update(profile_params)
      redirect_to profile_path, notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :avatar, :address, :website, :business_hours, :mobile, :show_email, :currency)
  end

  def set_exchange_rates
    response = Net::HTTP.get(URI('https://api.privatbank.ua/p24api/pubinfo?exchange&json&coursid=11'))
    @exchange_rates = JSON.parse(response)
    @exchange_rate = @exchange_rates.find { |rate| rate['ccy'] == current_user.currency }
  end
end
