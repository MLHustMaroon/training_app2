class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
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
    if user.update_attributes(user_params)
      redirect_to user_path(user)
    else
      flash.now[:danger] = 'cannot update profile'
      redirect_to edit_user_path(user)
    end
  end

  def destroy
    user = User.find params[:id]
    if user.destroy
      redirect_to admin_users_path
    else
      flash.now[danger] = 'can not delete user'
      redirect_to admin_user_path user
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end