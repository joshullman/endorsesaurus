class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
    	t.integer  :show_id
    	t.integer  :season_num
    	t.integer  :points
    	t.integer  :medium_id

      t.timestamps null: false
    end
  end
end
