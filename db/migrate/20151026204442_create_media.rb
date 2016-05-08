class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string   :type
      t.string   :specific_id

      t.timestamps null: false
    end
  end
end
