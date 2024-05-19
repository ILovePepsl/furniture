class CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection, only: %i[show edit update destroy add_all_to_cart]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @collections = Collection.all.sort_by { |c| [-c.average_rating, -c.created_at.to_i] }
  end

  def show
  end

  def new
    @collection = current_user.collections.build
  end

  def edit
  end

  def create
    @collection = current_user.collections.build(collection_params)
    if @collection.save
      redirect_to @collection, notice: 'Collection was successfully created.'
    else
      render :new
    end
  end

  def update
    if params[:reset_colors]
      @collection.update(background_color: nil, text_color: nil, title_color: nil, product_card_background_color: nil, product_description_color: nil, product_price_color: nil)
      redirect_to @collection, notice: 'Colors were successfully reset.'
    elsif @collection.update(collection_params)
      redirect_to @collection, notice: 'Collection was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @collection.destroy
    redirect_to collections_url, notice: 'Collection was successfully destroyed.'
  end

  def add_all_to_cart
    collection = Collection.find(params[:id])
    collection.products.each do |product|
      cart_product = current_user.cart.cart_products.find_or_initialize_by(product: product)
      cart_product.quantity ||= 0
      cart_product.quantity += 1
      cart_product.save
    end

    redirect_to cart_path(current_user.cart), notice: 'All products from the collection were added to your cart.'
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def authorize_user!
    unless current_user.admin? || current_user == @collection.user
      redirect_to collections_path, alert: 'You are not authorized to edit this collection.'
    end
  end

  def collection_params
    params.require(:collection).permit(:name, :background_color, :text_color, :title_color, :product_card_background_color, :product_description_color, :product_price_color)
  end
end
