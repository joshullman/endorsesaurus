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
