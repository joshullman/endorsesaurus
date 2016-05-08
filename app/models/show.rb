class Show < ActiveRecord::Base
	has_many :media
	has_many :media_genres
	has_many :genres, through: :media_genres
end