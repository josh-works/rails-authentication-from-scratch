class PasswordsController < ApplicationController
  # before_action :redirect_if_authenticated
  
  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user.present?
      if @user.confirmed?
        @user.send_password_reset_email!
        redirect_to root_path, alert: "please check your inbox for the password reset email"
      else
        redirect_to new_confirmation_path, alert: "your account seems to not be confirmed, please confirm it"
      end
    else
      redirect_to root_path, alert: "Invalid auth token"
    end
  end
  
  def update
    @user = User.find_signed(params[:password_reset_token], purpose: :reset_password)
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: "your account seems to be not confirmed, please confirm it"
      end
    end
  end
  
  def edit
  end
  
  def new
  end
  
  private
  
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
