class Medium < ActiveRecord::Base
	has_one     :show
	has_one     :movie
	has_one     :season
	has_one     :episode
	belongs_to  :media_type
	has_many    :recommendations
	has_many    :likes
	has_many    :media_tags
	has_many    :tags, through: :media_tags

	def find_associated_media
		case self.media_type_id
		when 1
			self.movie
		when 2
			self.show
		when 3
			self.season
		when 4
			self.episode
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
				self.liked_count = 0 if self.liked_count < 0
			when 0
				self.seen_count = self.seen_count - 1
				self.seen_count = 0 if self.seen_count < 0
			when -1
				self.disliked_count = self.disliked_count - 1
				self.disliked_count = 0 if self.disliked_count < 0
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
		self.recommended_count = 0 if self.recommended_count < 0
		self.save
	end
end
