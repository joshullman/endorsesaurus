class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :medium_id
      t.integer :value

      t.timestamps null: false
    end
  end
end
