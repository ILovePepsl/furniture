module ApplicationHelper
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
