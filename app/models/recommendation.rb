class Recommendation < ActiveRecord::Base
	belongs_to :user_one, class_name: "User"
	belongs_to :user_two, class_name: "User"
	belongs_to :medium

	def sender
		User.find(self.sender_id)
	end

	def receiver
		User.find(self.receiver_id)
	end
	
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
