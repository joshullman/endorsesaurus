class Medium < ActiveRecord::Base
	has_many :recommendations
	has_many :likes
	belongs_to :show

	def watched_count
		Like.where(media_id: self.id).count || 0
	end

	def liked_count
		Like.where(media_id: self.id).where(value: 1).count || 0
	end

	def seen_count
		Like.where(media_id: self.id).where(value: 0).count || 0
	end

	def disliked_count
		Like.where(media_id: self.id).where(value: -1).count || 0
	end

	def recommended_count
		Recommendation.where(media_id: self.id).count || 0
	end

	def recommended_to(user_id)
		User.where(Recommendation.where(sender: user_id).sender)
	end

	def recommended_by(user_id)
		Recommendation.where(receiver: user_id)
	end
end
