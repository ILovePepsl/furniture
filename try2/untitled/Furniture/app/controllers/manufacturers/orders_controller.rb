module Manufacturers
  class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_manufacturer!

    def index
      @users = User.joins(orders: :order_products)
                   .where(order_products: { product: current_user.products })
                   .distinct

      if params[:search].present?
        @users = @users.where('users.email LIKE ?', "%#{params[:search]}%")
      end

      @users = @users.page(params[:page]).per(10)
    end

    def show
      @order = Order.find(params[:id])
      @order_products = @order.order_products.joins(:product).where(products: { manufacturer_id: current_user.id })
    end

    def user_orders
      @user = User.find(params[:id])
      @orders = @user.orders.joins(:order_products)
                     .where(order_products: { product: current_user.products })
                     .distinct

      if params[:search].present?
        @orders = @orders.where('orders.id = ?', params[:search])
      end

      @orders = @orders.page(params[:page]).per(10)
    end

    def update
      @order_product = OrderProduct.find(params[:id])
      if @order_product.update(order_product_params)
        redirect_to manufacturers_order_path(@order_product.order), notice: 'Order status updated successfully.'
      else
        redirect_to manufacturers_order_path(@order_product.order), alert: 'Failed to update order status.'
      end
    end

    def order_products
      @order_products = OrderProduct.joins(:product)
                                    .where(products: { manufacturer_id: current_user.id })
                                    .order(:status)

      if params[:status].present?
        @order_products = @order_products.where(status: params[:status])
      end

      @order_products = @order_products.page(params[:page]).per(10)
    end

    private

    def authorize_manufacturer!
      redirect_to root_path, alert: 'You are not authorized to view this page.' unless current_user.manufacturer?
    end

    def order_product_params
      params.require(:order_product).permit(:status, :manufacturer_start_date, :manufacturer_end_date)
    end
  end
end
