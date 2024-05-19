require 'rss'

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :authorize_manufacturer!, only: %i[edit update destroy]
  before_action :authorize_manufacturer_for_create!, only: %i[new create]
  before_action :set_exchange_rates, only: %i[index show]

  helper_method :convert_price

  def index
    @products = Product.all
    if params[:search].present?
      @products = @products.where("LOWER(name) LIKE ?", "%#{params[:search].downcase}%")
    end
    @products = sort_by_rating(@products, params[:order])
    @products = @products.page(params[:page]).per(15)
  end

  def show
    @product = Product.includes(:manufacturer, :category).find(params[:id])
    @converted_price = convert_price(@product.price)
  end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = Product.new(product_params)
    @product.manufacturer = current_user if current_user.manufacturer?

    respond_to do |format|
      if @product.save
        notify_subscribers(@product)
        format.html { redirect_to product_url(@product), notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy!
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def rss
    @user = User.find(params[:user_id])
    @products = @user.products

    respond_to do |format|
      format.rss do
        render_rss_feed(@products)
      end
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :image, :category_id)
  end

  def authorize_manufacturer!
    unless current_user == @product.manufacturer
      redirect_to product_path(@product), alert: 'You are not authorized to edit this product.'
    end
  end

  def authorize_manufacturer_for_create!
    unless current_user&.manufacturer?
      redirect_to root_path, alert: 'You are not authorized to create products.'
    end
  end

  def sort_by_rating(products, order)
    if order == 'asc'
      products.left_joins(:reviews).group(:id).order(Arel.sql('AVG(reviews.rating) ASC NULLS LAST'))
    else
      products.left_joins(:reviews).group(:id).order(Arel.sql('AVG(reviews.rating) DESC NULLS LAST'))
    end
  end

  def set_exchange_rates
    response = Net::HTTP.get(URI('https://api.privatbank.ua/p24api/pubinfo?exchange&json&coursid=11'))
    @exchange_rates = JSON.parse(response)
  end

  def convert_price(price_in_uah)
    return price_in_uah if current_user.nil? || current_user.currency == 'UAH'

    exchange_rate = @exchange_rates.find { |rate| rate['ccy'] == current_user.currency }
    return price_in_uah unless exchange_rate

    price_in_uah / exchange_rate['sale'].to_f
  end

  def notify_subscribers(product)
    product.manufacturer.subscribers.each do |subscriber|
      ProductMailer.with(user: subscriber, product: product).new_product_email.deliver_later
    end
  end

  def render_rss_feed(products)
    rss = RSS::Maker.make("2.0") do |maker|
      maker.channel.author = "Your App Name"
      maker.channel.updated = Time.now.to_s
      maker.channel.about = "Product updates"
      maker.channel.title = "Product RSS Feed"

      products.each do |product|
        maker.items.new_item do |item|
          item.link = product_url(product)
          item.title = product.name
          item.updated = product.updated_at.to_s
          item.description = product.description
        end
      end
    end
    render xml: rss.to_xml
  end
end
