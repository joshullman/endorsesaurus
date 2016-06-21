class CreateWatchedRecNotes < ActiveRecord::Migration
  def change
    create_table :watched_rec_notes do |t|
    	t.integer  :sender_id
      t.integer  :receiver_id
    	t.integer  :medium_id
    	t.integer  :value
    	t.integer  :points
    	t.string   :media_type

      t.timestamps null: false
    end
  end
end
