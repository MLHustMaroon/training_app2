module TasksHelper

  def tags_string task
    str = ''
    task.tags.each do |tag|
      str += tag.label + ', '
    end
    str
  end

  def retrieve_tag_from_string str
    label_arr = str.split(',')
    tag_arr = []
    label_arr.each do |tag_label|
      tag = Tag.find_by(label: tag_label)
      if (!tag_label.blank? && tag.nil?)
        tag = Tag.new(label: tag_label)
        tag.save
      end
      tag_arr << tag unless tag.nil?
    end
    tag_arr
  end

  def filter_tasks(params, tasks)
    unless params[:task_filter][:priority].blank?
      if params[:task_filter][:priority_condition] == Task::FILTER_CONDITION[:is].to_s
        tasks = tasks.where(priority: params[:task_filter][:priority])
      else
        tasks = tasks.where.not(priority: params[:task_filter][:priority])
      end
    end

    unless params[:task_filter][:status].blank?
      if params[:task_filter][:status_condition] == Task::FILTER_CONDITION[:is].to_s
        tasks = tasks.where(status: params[:task_filter][:status])
      else
        tasks = tasks.where.not(status: params[:task_filter][:status])
      end
    end

    unless params[:task_filter][:tags].blank?
      tags = retrieve_tag_from_string params[:task_filter][:tags]
      tag_ids = []
      tags.each do |tag|
        tag_ids << tag.id
      end
      tasks = tasks.includes(:tags).where('tags.id' => tag_ids)
    end

    unless params[:task_filter][:sort_options].blank?
      option = params[:task_filter][:sort_options]
      tasks = if option == Task::SORT_OPTIONS[:by_pritority]
                tasks.order("priority #{params[:task_filter][:sort_order]}")
              else
                tasks.order("status #{params[:task_filter][:sort_order]}")
              end
    end
    tasks = tasks.page params[:page]
  end
end
