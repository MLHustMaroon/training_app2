class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

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
      flash.now[:success] = 'registration successfully'
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

  private

  def correct_user
    user = User.find(params[:id])
    unless user == current_user
      flash.now[:danger] = 'you dont have permission to access this site'
      redirect_to root_path
    end
  end
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
