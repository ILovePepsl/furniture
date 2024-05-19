class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    @subscription = current_user.subscriptions.new(manufacturer: @user)
    if @subscription.save
      redirect_to @user, notice: 'Successfully subscribed.'
    else
      redirect_to @user, alert: 'Subscription failed.'
    end
  end

  def destroy
    @subscription = current_user.subscriptions.find_by(manufacturer: @user)
    @subscription.destroy
    redirect_to @user, notice: 'Successfully unsubscribed.'
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
