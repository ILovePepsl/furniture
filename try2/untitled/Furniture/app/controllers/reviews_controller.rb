class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product

  def create
    @review = @product.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      redirect_to @product, notice: 'Review added successfully.'
    else
      redirect_to @product, alert: 'You have already reviewed this product.'
    end
  end

  def destroy
    @review = Review.find(params[:id])

    if @review.user == current_user || current_user.admin?
      @review.destroy
      redirect_to @product, notice: 'Review was successfully removed.'
    else
      redirect_to @product, alert: 'You are not authorized to delete this review.'
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def review_params
    params.require(:review).permit(:comment, :rating)
  end
end
