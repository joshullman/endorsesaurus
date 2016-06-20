class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.integer  :medium_id
      t.string   :omdb_id
      t.string   :imdb_id
      t.string   :title
      t.string   :year
      t.string   :rated
      t.string   :released
      t.string   :runtime
      t.string   :director
      t.string   :writer
      t.string   :actors
      t.string   :plot
      t.string   :poster
      t.integer  :points

      t.timestamps null: false
    end
  end
end
