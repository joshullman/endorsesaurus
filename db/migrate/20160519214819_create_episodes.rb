class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
    	t.integer  :season_id
      t.integer  :show_id
    	t.integer  :medium_id
    	t.integer  :episode_num
      t.integer  :season_num
      t.string   :omdb_id
      t.string   :imdb_id
    	t.string   :title
    	t.string   :plot
    	t.string   :runtime
      t.string   :released
      t.string   :writer
      t.string   :director
      t.string   :plot
      t.string   :actors
      t.string   :poster
      t.integer  :points

      t.timestamps null: false
    end
  end
end
