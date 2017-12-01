class CreateProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.references :user, foreign_key: true
      t.string :avatar
      t.integer :gender
      t.text :bio
      t.integer :age

      t.timestamps
    end
  end
end
