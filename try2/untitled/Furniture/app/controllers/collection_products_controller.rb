class CollectionProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection

  def create
    if current_user.admin? || @collection.user == current_user
      product = Product.find(params[:product_id])
      if current_user.admin? || product.manufacturer == current_user
        @collection.products << product
        redirect_to @collection, notice: 'Product was successfully added to the collection.'
      else
        redirect_to @collection, alert: 'You are not authorized to add this product to the collection.'
      end
    else
      redirect_to @collection, alert: 'You are not authorized to add products to this collection.'
    end
  end

  def destroy
    if current_user.admin? || @collection.user == current_user
      product = Product.find(params[:id])
      @collection.products.delete(product)
      redirect_to @collection, notice: 'Product was successfully removed from the collection.'
    else
      redirect_to @collection, alert: 'You are not authorized to remove products from this collection.'
    end
  end

  private

  def set_collection
    @collection = Collection.find(params[:collection_id])
  end
end
