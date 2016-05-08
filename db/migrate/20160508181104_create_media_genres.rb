class CreateMediaGenres < ActiveRecord::Migration
  def change
    create_table :media_genres do |t|
    	t.integer  :medium_id, default: nil
    	t.integer  :show_id, default: nil
    	t.integer  :genre_id

      t.timestamps null: false
    end
  end
end
