class TasksController < ApplicationController
  include TasksHelper
  before_action :correct_user, only: [ :edit, :update, :destroy, :show ]
  before_action :loggedin, only: [:new, :create]

  autocomplete :tag, :label

  def new
    @task = current_user.tasks.build
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(user: current_user)
    if @task.update_attributes task_params
      redirect_to @task
    else
      flash.now[:danger] = 'unable to create new task'
      render 'new'
    end
  end

  def update
    @task = Task.find(params[:id])
    unless @task.update_attributes(task_params)
    flash.now[:danger] = 'unable to update task'
    end
    redirect_to @task
  end

  def index
    if request.post?
      @tasks = filter_tasks(params, current_user.tasks)
      session[:search_params] = params
    else
      if params[:page]
        @tasks = filter_tasks(params, current_user.tasks)
      else
        @tasks = current_user.tasks.page params[:page]
        session.delete(:search_params)
      end
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def destroy
    @task = Task.find(params[:id])
    unless @task.destroy
      flash.now[:danger] = 'can not remove task'
      redirect_to @task
    end
    redirect_to tasks_path
  end

  private
  def task_params
    params.require(:task).permit(:content, :priority, :status, :deadline, :tags)
  end

  def correct_user
    @task = Task.find(params[:id])
    unless @task.belongs_to?(current_user)
      flash.now[:warning] = 'you don\'t have permission to access this page'
      redirect_to root_path
    end
  end

  def loggedin
    unless logged_in?
      flash.now[:danger] = 'please log in first'
      redirect_to login_path
    end
  end
end
