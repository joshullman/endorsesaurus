class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
    	t.string   :media_type
    	t.integer  :recommended_count, default: 0
    	t.integer  :watched_count, default: 0
    	t.integer  :liked_count, default: 0
    	t.integer  :seen_count, default: 0
    	t.integer  :disliked_count, default: 0


      t.timestamps null: false
    end
  end
end
