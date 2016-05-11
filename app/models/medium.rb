class Medium < ActiveRecord::Base
	has_many :recommendations
	has_many :likes
	has_many :shows
	has_many :movies
	has_many :seasons
	has_many :media_tags
	has_many :tags, through: :media_tags

	def find_associated_media
		case self.media_type
		when "Movie"
			Movie.find(self.related_id)
		when "Show"
			Show.find(self.related_id)
		when "Season"
			Season.find(self.related_id)
		end
	end

	def watched_count
		Like.where(medium_id: self.id).count || 0
	end

	def liked_count
		Like.where(medium_id: self.id).where(value: 1).count || 0
	end

	def seen_count
		Like.where(medium_id: self.id).where(value: 0).count || 0
	end

	def disliked_count
		Like.where(medium_id: self.id).where(value: -1).count || 0
	end

	def recommended_count
		Recommendation.where(medium_id: self.id).count || 0
	end

	def recommended_to(user_id)
		recs = self.recommendations.where(sender_id: user_id)
		users = []
		recs.each do |rec|
			users << rec.receiver
		end
		users
	end

	def recommended_by(user_id)
		recs = self.recommendations.where(receiver_id: user_id)
		users = []
		recs.each do |rec|
			users << rec.sender
		end
		users
	end
end
