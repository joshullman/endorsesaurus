class Medium < ActiveRecord::Base
	has_many :recommendations
	has_many :likes
	has_many :shows
	has_many :movies
	has_many :seasons
	has_many :episodes
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
		when "Episode"
			Episode.find(self.related_id)
		end
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

	def increment_likes(value)
		case value
			when 1
				self.liked_count = self.liked_count + 1
			when 0
				self.seen_count = self.seen_count + 1
			when -1
				self.disliked_count = self.disliked_count + 1
		end
		self.save
	end

	def decrement_likes(value)
		case value
			when 1
				self.liked_count = self.liked_count - 1
			when 0
				self.seen_count = self.seen_count - 1
			when -1
				self.disliked_count = self.disliked_count - 1
		end
		self.save
	end

	def increment_watches
		self.watched_count = self.watched_count + 1
		self.save
	end

	def increment_recommends
		self.recommended_count = self.recommended_count + 1
		self.save
	end

	def decrement_recommends
		self.recommended_count = self.recommended_count - 1
		self.save
	end
end
