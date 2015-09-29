class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.integer  :imdb_id
      t.integer  :points

      t.timestamps null: false
    end
  end
end
