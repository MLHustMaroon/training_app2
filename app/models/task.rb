class Task < ApplicationRecord
  # default_scope {order(created_at: :desc)}
  validates :content, presence: true, length: {maximum: 255, minimum: 6}
  STATUS_HASH = {not_started: 1, undertaken: 2, completed: 3}
  PRIORITY_HASH = {low: 1, normal: 2, high: 3, urgent: 4, immidiate: 5}
  FILTER_CONDITION = {is: 1, is_not: 2}
end
