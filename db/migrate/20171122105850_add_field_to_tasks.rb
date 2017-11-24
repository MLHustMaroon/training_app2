class AddFieldToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :content, :string
    add_column :tasks, :priority, :integer
    add_column :tasks, :status, :integer
    add_column :tasks, :deadline, :datetime
  end
end
