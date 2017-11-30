class Tag < ApplicationRecord
  has_and_belongs_to_many :tasks
  validates :label, uniqueness: true, presence: true
  before_save { self.label = self.label.gsub(/\s+/, '') }

end
