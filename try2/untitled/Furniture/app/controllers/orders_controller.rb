class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy]

  def index
    @orders = current_user.orders
  end

  def show
    @order_products = @order.order_products.includes(:product)
  end

  def new
    @order = Order.new
  end

  def edit; end

  def create
    @cart = current_user.cart
    if @cart.cart_products.empty?
      redirect_to cart_path(@cart), alert: 'Your cart is empty.'
      return
    end

    @order = current_user.orders.build(order_params)

    total_price = @cart.cart_products.sum do |cart_product|
      cart_product.product.price * cart_product.quantity
    end
    @order.total_price = total_price

    @order.status = 'In processing'

    respond_to do |format|
      if @order.save
        @cart.cart_products.each do |cart_product|
          @order.order_products.create(product: cart_product.product, quantity: cart_product.quantity)
        end

        @cart.cart_products.destroy_all

        format.html { redirect_to order_url(@order), notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:first_name, :last_name, :phone, :address, :total_price, :status, :user_start_date, :user_end_date)
  end
end
