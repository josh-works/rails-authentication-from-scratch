class ConfirmationsController < ApplicationController
  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    
    if @user.present? && @user.unconfirmted?
      redirect_to root_path, notice: "Check your email for confirmation instructions."
    else
      redirect_to new_confirmation_path, alert: "we could not find a user with that email, or that email has been confirmted already"
    end
  end
  
  def edit
    @user = User.find_signed(params[:confirmation_token], purpose: :confirm_email)
    
    if @user.present?
      @user.confirm!
      redirect_to root_path, notice: "your account is confirmed"
    else
      redirect_to new_confirmation_path, alert: "invalid token"
    end
    
  end
  
  def new
    @user = User.new
  end
end