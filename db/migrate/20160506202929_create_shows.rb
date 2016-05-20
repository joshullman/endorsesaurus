class CreateShows < ActiveRecord::Migration
  def change
  	create_table :shows do |t|
  		t.string   :title
  		t.string   :year
  		t.string   :rated
  		t.string   :released
  		t.string   :creator
  		t.string   :actors
  		t.string   :plot
  		t.string   :poster
  		t.string   :imdb_id
      t.integer  :medium_id

  		t.timestamps null: false
    end
  end
end
