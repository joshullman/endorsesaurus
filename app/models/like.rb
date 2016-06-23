class Like < ActiveRecord::Base
	belongs_to :user
	belongs_to :medium

	def find_associated_media
		case self.medium.media_type
		when "Movie"
			self.medium.movie
		when "Show"
			self.medium.show
		when "Season"
			self.medium.season
		when "Episode"
			self.medium.episode
		end
	end

end
