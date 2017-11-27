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
    priority_sort = 'ASC'
    deadline_sort = 'ASC'
    if params[:deadline_sort]
      @tasks = current_user.tasks.order("deadline #{params[:deadline_sort]}").page params[:page]
      deadline_sort = params[:deadline_sort]
    elsif params[:priority_sort]
      @tasks = current_user.tasks.order("priority #{params[:priority_sort]}").page params[:page]
      priority_sort = params[:priority_sort]
    else
      @tasks = current_user.tasks.page params[:page]
    end
    if defined? params[:tag]
      @tasks = @tasks.includes(:tags).where('tags.label' => params[:tag] )
    end
    @sorts = {deadline: deadline_sort, priority: priority_sort}
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

  def filter
    @tasks = Task.all.page params[:page]
    unless params[:task_filter][:priority].blank?
      if params[:task_filter][:priority_condition] == Task::FILTER_CONDITION[:is].to_s
        @tasks = @tasks.where(priority: params[:task_filter][:priority])
      else
        @tasks = @tasks.where.not(priority: params[:task_filter][:priority])
      end
    end

    unless params[:task_filter][:status].blank?
      if params[:task_filter][:status_condition] == Task::FILTER_CONDITION[:is].to_s
        @tasks = @tasks.where(status: params[:task_filter][:status])
      else
        @tasks = @tasks.where.not(status: params[:task_filter][:status])
      end
    end

    unless params[:task_filter][:tags].blank?
      tags = retrieve_tag_from_string params[:task_filter][:tags]
      tag_ids = []
      tags.each do |tag|
        tag_ids << tag.id
      end
      @tasks = @tasks.includes(:tags).where('tags.id' => tag_ids)
    end
    render 'index'
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
