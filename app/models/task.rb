class Task < ApplicationRecord
  include TasksHelper
  # default_scope {order(created_at: :desc)}
  validates :content, presence: true, length: {maximum: 255, minimum: 6}
  STATUS_HASH = {not_started: 1, undertaken: 2, completed: 3}
  PRIORITY_HASH = {low: 1, normal: 2, high: 3, urgent: 4, immidiate: 5}
  FILTER_CONDITION = {is: 1, is_not: 2}

  belongs_to :user
  has_and_belongs_to_many :tags

  def belongs_to? user
    self.user == user
  end

  def update_tag str
    tags = retrieve_tag_from_string str
    self.tags.delete(self.tags)
    self.tags << tags
  end

  def update_attributes params
    tag_str = params[:tags]
    params.delete(:tags)
    # if Parent.update_attributes(params)
    if ApplicationRecord.instance_method(:update_attributes).bind(self).call params
      self.update_tag tag_str
      true
    else
      false
    end
  end
end
