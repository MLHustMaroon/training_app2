class Admin::UsersController < ApplicationController

  before_action :admin_authenticate

  def index
    @users = User.common_users
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    user = User.find params[:id]
    unless user.update_attributes(user_params)
      flash.now[:danger] = 'cannot update profile'
    end
    redirect_to edit_user_path(user)
  end

  def destroy
    user = User.find params[:id]
    unless user.destroy
      flash.now[:danger] = 'cannot delete user'
    end
    redirect_to admin_users_path
  end
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
