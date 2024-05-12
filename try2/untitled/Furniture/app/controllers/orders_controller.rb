# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy]

  # GET /orders or /orders.json
  def index
    # Отображает только заказы текущего пользователя
    @orders = current_user.orders
  end

  def show
    @order_products = @order.order_products.includes(:product)
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit; end

  # POST /orders or /orders.json
  def create
    @cart = current_user.cart
    # Проверка на наличие товаров в корзине перед созданием заказа
    if @cart.cart_products.empty?
      redirect_to cart_path(@cart), alert: 'Your cart is empty.'
      return
    end

    @order = current_user.orders.build(order_params)

    # Рассчитываем общую стоимость заказа
    total_price = @cart.cart_products.sum do |cart_product|
      cart_product.product.price * cart_product.quantity
    end
    @order.total_price = total_price

    # Устанавливаем статус заказа по умолчанию
    @order.status = 'In processing'

    respond_to do |format|
      if @order.save
        # Переносим товары из корзины в заказ
        @cart.cart_products.each do |cart_product|
          @order.order_products.create(product: cart_product.product, quantity: cart_product.quantity)
        end

        # Очищаем корзину после оформления заказа
        @cart.cart_products.destroy_all

        format.html { redirect_to order_url(@order), notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
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

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Использует обратные вызовы для общего настроения или ограничений между действиями.
  def set_order
    @order = current_user.orders.find(params[:id])
  end

  # Разрешаем только доверенные параметры
  def order_params
    params.require(:order).permit(:first_name, :last_name, :phone, :address, :total_price, :status)
  end
end
