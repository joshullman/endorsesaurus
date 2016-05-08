class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
    	t.string   :media_type
    	t.integer  :related_id, default: nil

      t.timestamps null: false
    end
  end
end
