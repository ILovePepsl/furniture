class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products

    if params[:search].present?
      @products = @products.where("name LIKE ?", "%#{params[:search]}%")
    end

    if params[:order].present?
      @products = sort_by_rating(@products, params[:order])
    end

    @products = @products.page(params[:page]).per(15)
  end

  private

  def sort_by_rating(products, order)
    if order == 'asc'
      products.left_joins(:reviews).group(:id).order(Arel.sql('AVG(reviews.rating) ASC NULLS LAST'))
    else
      products.left_joins(:reviews).group(:id).order(Arel.sql('AVG(reviews.rating) DESC NULLS LAST'))
    end
  end
end
