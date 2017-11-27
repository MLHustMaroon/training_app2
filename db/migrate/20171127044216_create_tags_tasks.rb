class CreateTagsTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tags_tasks, id: false do |t|
      t.references :tag, foreign_key: true
      t.references :task, foreign_key: true
    end
    add_index :tags_tasks, :tag_id
    add_index :tags_tasks, :task_id
  end
end
