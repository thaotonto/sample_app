class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
    only: [:edit, :update]

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "forgot_password.info"
      redirect_to root_url
    else
      flash.now[:danger] = t "forgot_password.not_found"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add t("forgot_password.user_error_add")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t "forgot_password.success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]

    return if @user
    flash[:danger] = t ".cannot_find_user"
    redirect_to root_url
  end

  def valid_user
    return if @user&.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "forgot_password.expired"
    redirect_to new_password_reset_url
  end
end
