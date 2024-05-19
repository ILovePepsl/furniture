class ProductMailer < ApplicationMailer
  helper :application

  def new_product_email
    @user = params[:user]
    @product = params[:product]
    @currency = @user.currency
    @converted_price = convert_price(@product.price, @user)
    mail(to: @user.email, subject: 'New Product Available')
  end

  private

  def convert_price(price_in_uah, user)
    return price_in_uah if user.currency == 'UAH'

    exchange_rate = Rails.cache.fetch("exchange_rates/#{user.currency}", expires_in: 12.hours) do
      response = Net::HTTP.get(URI('https://api.privatbank.ua/p24api/pubinfo?exchange&json&coursid=11'))
      JSON.parse(response).find { |rate| rate['ccy'] == user.currency }
    end
    return price_in_uah unless exchange_rate

    price_in_uah / exchange_rate['sale'].to_f
  end
end
