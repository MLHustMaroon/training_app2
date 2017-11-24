class ChangeTaskContentType < ActiveRecord::Migration[5.1]
  def change
    change_column :tasks, :content, :text
  end
end
