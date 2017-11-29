class SessionsController < ApplicationController

  def new
    session.delete(:user_id)
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      remember user
      if is_admin?
        redirect_to admin_users_path
      else
        redirect_to user
      end
    else
      flash.now[:danger] = 'invalid email/password'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

end
