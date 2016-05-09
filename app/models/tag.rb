class Tag < ActiveRecord::Base
	has_many :media_tags
	has_many :media, through: :media_tags

	def movies
		media = self.media.where(media_type: "Movie")
		movies = []
		media.each do |medium|
			movies << medium.find_associated_media
		end
		movies
	end

	def shows
		media = self.media.where(media_type: "Show")
		shows = []
		media.each do |medium|
			shows << medium.find_associated_media
		end
		shows
	end
end
