class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
    	t.integer  :user_one_id
    	t.integer  :user_two_id, default: 0
    	t.integer  :medium_id, default: 0
    	t.string   :media_type
    	t.string   :notification_type
      t.timestamps null: false
    end
  end
end
