class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
    	t.integer  :season_id
    	t.integer  :omdb_id
    	t.string   :imdb_id
    	t.string   :medium_id
    	t.integer  :episode_num
    	t.string   :episode_title
    	t.string   :plot
    	t.integer  :runtime
      t.string   :released
      t.string   :writer
      t.string   :director
      t.string   :plot
      t.string   :actors
      t.string   :poster

      t.timestamps null: false
    end
  end
end
