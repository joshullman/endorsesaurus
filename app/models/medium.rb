class Medium < ActiveRecord::Base
	has_many :recommendations
	has_many :likes
	belongs_to :show

	# likes = Like.where(media_id: self.id)
	# @users_watched = likes.count
	# @users_like = likes.where(value: 1).count
	# @users_seen = likes.where(value: 0).count
	# @users_dislike = likes.where(value: -1).count
	# @recommendation_count = Recommendation.where(media_id: @medium.id).count

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

end
