class CreateMediaGenres < ActiveRecord::Migration
  def change
    create_table :media_genres do |t|
    	t.integer  :media_id
    	t.integer  :genre_id

      t.timestamps null: false
    end
  end
end
