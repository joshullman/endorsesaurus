class CreateWatchedNotes < ActiveRecord::Migration
  def change
    create_table :watched_notes do |t|
    	t.integer  :user_id
    	t.integer  :medium_id
    	t.integer  :value
    	t.string   :media_type

      t.timestamps null: false
    end
  end
end
