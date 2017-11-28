class Admin::TasksController < ApplicationController
  include TasksHelper
  before_action :admin_authenticate

  def index
    if request.post?
      @tasks = filter_tasks(params, Task.all)
      session[:search_params] = params
    else
      if params[:page]
        @tasks = filter_tasks(params, Task.all)
      else
        @tasks = Task.all.page params[:page]
        session.delete(:search_params)
      end
    end
  end
end
