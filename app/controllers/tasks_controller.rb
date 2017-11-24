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
    @tasks = Task.all
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
    params.require(:task).permit(:content, :priority, :status, :deadline)
  end
end
