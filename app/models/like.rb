class Like < ActiveRecord::Base
	belongs_to :user
	belongs_to :medium

	def find_associated_media
		medium = self.medium
		case medium.media_type
		when "Movie"
			Movie.find(medium.related_id)
		when "Show"
			Show.find(medium.related_id)
		when "Season"
			Season.find(medium.related_id)
		end
	end
end
