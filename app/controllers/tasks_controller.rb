class TasksController < ApplicationController
  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    if @task.save
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
      @tasks = Task.all.order("deadline #{params[:deadline_sort]}").page params[:page]
      deadline_sort = params[:deadline_sort]
    elsif params[:priority_sort]
      @tasks = Task.all.order("priority #{params[:priority_sort]}").page params[:page]
      priority_sort = params[:priority_sort]
    else
      @tasks = Task.all.page params[:page]
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
    @tasks = Task.all
    if params[:task_filter][:priority_condition] == Task::FILTER_CONDITION[:is].to_s
      @tasks = @tasks.where(priority: params[:task_filter][:priority])
    else
      @tasks = @tasks.where.not(priority: params[:task_filter][:priority])
    end

    if params[:task_filter][:status_condition] == Task::FILTER_CONDITION[:is].to_s
      @tasks = @tasks.where(status: params[:task_filter][:status])
    else
      @tasks = @tasks.where.not(status: params[:task_filter][:status])
    end
    render 'index'
  end

  private
  def task_params
    params.require(:task).permit(:content, :priority, :status, :deadline)
  end
end
