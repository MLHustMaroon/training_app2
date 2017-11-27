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
end
