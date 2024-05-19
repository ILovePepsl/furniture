class WishlistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wishlist

  def show
  end

  def add_product
    product = Product.find(params[:product_id])
    unless @wishlist.products.include?(product)
      @wishlist.products << product
    end
    redirect_to wishlist_path, notice: 'Product added to wishlist.'
  end

  def remove_product
    product = Product.find(params[:product_id])
    @wishlist.products.delete(product)
    redirect_to wishlist_path, notice: 'Product removed from wishlist.'
  end

  private

  def set_wishlist
    @wishlist = current_user.wishlist || current_user.create_wishlist
  end
end
