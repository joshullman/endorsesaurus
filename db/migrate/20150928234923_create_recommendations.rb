class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer  :sender_id
      t.integer  :receiver_id
      t.integer  :medium_id
      t.string   :media_type

      t.timestamps null: false
    end
  end
end
