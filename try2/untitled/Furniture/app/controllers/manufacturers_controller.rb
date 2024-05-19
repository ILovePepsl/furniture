class ManufacturersController < ApplicationController
  def show
    @manufacturer = User.find(params[:id])
    @products = Product.where(manufacturer_id: @manufacturer.id).page(params[:page])
    @category = nil #для выделения выбранной категории
  end

end
