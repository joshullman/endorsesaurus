class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer  :sender
      t.integer  :receiver
      t.integer  :medium_id

      t.timestamps null: false
    end
  end
end
