class Genre < ActiveRecord::Base
	has_many :media_genres
	has_many :media, through: :media_genres
	has_many :shows, through: :media_genres
end
