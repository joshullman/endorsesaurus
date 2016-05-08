class Medium < ActiveRecord::Base
	has_many :recommendations
	has_many :likes
	has_many :media_genres
	has_many :genres, through: :media_genres
	belongs_to :show

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
		recs = self.recommendations.where(sender: user_id)
		users = []
		recs.each do |rec|
			users << User.find(rec.receiver)
		end
		users
	end

	def recommended_by(user_id)
		recs = self.recommendations.where(receiver: user_id)
		users = []
		recs.each do |rec|
			users << User.find(rec.sender)
		end
		users
	end
end
