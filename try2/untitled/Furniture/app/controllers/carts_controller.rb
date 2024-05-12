class CartsController < ApplicationController
  before_action :set_cart, only: %i[show edit update destroy add_product remove_product update_quantity]

  def index
    @carts = Cart.all
  end

  def show
    @cart_products = @cart.cart_products.includes(:product)
  end


  def new
    @cart = Cart.new
  end

  def edit; end

  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to cart_url(@cart), notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to cart_url(@cart), notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cart.destroy!

    respond_to do |format|
      format.html { redirect_to carts_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_product
    product = Product.find(params[:product_id])
    cart_product = @cart.cart_products.find_or_initialize_by(product: product)
    cart_product.quantity ||= 0
    cart_product.quantity += 1
    cart_product.save

    respond_to do |format|
      format.html { redirect_to cart_url(@cart), notice: "#{product.name} added to your cart." }
      format.json { render :show, status: :ok, location: @cart }
    end
  end

  def update_quantity
    product = Product.find(params[:product_id])
    cart_product = @cart.cart_products.find_by(product: product)

    if cart_product && params[:quantity].to_i >= 1
      cart_product.update(quantity: params[:quantity].to_i)
    end

    respond_to do |format|
      format.html { redirect_to cart_url(@cart), notice: 'Quantity updated.' }
      format.json { render :show, status: :ok, location: @cart }
    end
  end

  def remove_product
    product = Product.find(params[:product_id])
    cart_product = @cart.cart_products.find_by(product: product)

    if cart_product
      cart_product.destroy
      notice = "#{product.name} removed from your cart."
    else
      notice = "Product not found in your cart."
    end

    respond_to do |format|
      format.html { redirect_to cart_url(@cart), notice: notice }
      format.json { render :show, status: :ok, location: @cart }
    end
  end

  private

  def set_cart
    @cart = current_user.cart
  end

  def cart_params
    params.require(:cart).permit(:user_id, :completed)
  end
end
