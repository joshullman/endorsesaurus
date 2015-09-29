class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer  :sender_id
      t.integer  :receiver_id
      t.integer  :media_id
      t.boolean  :liked, default: nil

      t.timestamps null: false
    end
  end
end
