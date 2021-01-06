# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :user_logged_in, only: %i[index edit update destroy]
  before_action :correct_user, only: %i[edit update]
  before_action :user_admin, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])

    redirect_to root_path and return unless @user.activated

    @microposts = @user.microposts.paginate page: params[:page]
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email

      flash[:info] = 'Please check your email to activate your account.'

      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]

    if @user.update user_params
      flash[:success] = 'Successfuly updated'

      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find params[:id]

    if user.delete
      flash[:success] = 'User deleted'

      redirect_to users_path
    else
      render 'index'
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  def correct_user
    @user = User.find params[:id]

    redirect_to login_path unless current_user? @user
  end

  def user_admin
    redirect_to root_path unless current_user.admin?
  end
end
