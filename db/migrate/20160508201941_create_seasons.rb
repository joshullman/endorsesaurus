class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.integer  :show_id
      t.integer  :medium_id
      t.integer  :omdb_id
      t.string   :imdb_id
      t.string   :title
      t.integer  :season_num
      t.integer  :points


      t.timestamps null: false
    end
  end
end
