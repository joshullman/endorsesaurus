class Season < ActiveRecord::Base
	belongs_to :show
	belongs_to :medium
	has_many   :episodes


	def watch_all(user, value)
		if !Like.where(user_id: user.id, medium_id: self.medium.id).first
			Like.create(user_id: user.id, medium_id: self.medium.id, value: value) 
		else
			like = Like.where(user_id: user.id, medium_id: self.medium.id)
			old_value = like.first.value
			like.first.value = value
			like.first.save
			self.medium.increment_likes(value)
	    self.medium.decrement_likes(old_value)
		end
		self.episodes.each do |episode|
			episode.medium.increment_watches
			self.medium.increment_watches
			self.show.medium.increment_watches
			episode.medium.increment_likes(value)
			self.medium.increment_likes(value)
			self.show.medium.increment_likes(value)
			if !Like.where(user_id: user.id, medium_id: episode.medium.id).first
				Like.create(user_id: user.id, medium_id: episode.medium.id, value: value) 
			else
				like = Like.where(user_id: user.id, medium_id: episode.medium.id)
				old_value = like.first.value
				like.first.value = value
				like.first.save
				episode.medium.increment_likes(value)
		    episode.medium.decrement_likes(old_value)
			end
		end
		case value
			when 1
				Notification.create(user_one_id: user.id, medium_id: self.medium.id, notification_type: "like")
			when 0
				Notification.create(user_one_id: user.id, medium_id: self.medium.id, notification_type: "seen")
			when -1
				Notification.create(user_one_id: user.id, medium_id: self.medium.id, notification_type: "dislike")
		end
	end

	def update_likes(user, value)
		like = Like.where(user_id: user.id, medium_id: self.medium.id)
		old_value = like.first.value
		like.first.value = value
		like.first.save
		self.medium.increment_likes(value)
    self.medium.decrement_likes(old_value)
	  self.episodes.each do |episode|
      like = Like.where(user_id: user.id, medium_id: episode.medium.id)
      old_value = like.first.value
      like.first.value = value
      like.first.save
      episode.medium.increment_likes(value)
      episode.medium.decrement_likes(old_value)
    end
    case value
			when 1
				Notification.create(user_one_id: user.id, medium_id: self.medium.id, notification_type: "like")
			when 0
				Notification.create(user_one_id: user.id, medium_id: self.medium.id, notification_type: "seen")
			when -1
				Notification.create(user_one_id: user.id, medium_id: self.medium.id, notification_type: "dislike")
		end
	end

	def liked
		(self.medium.liked_count.to_f / self.medium.watched_count.to_f * 100).round
	end

	def seen
		(self.medium.seen_count.to_f / self.medium.watched_count.to_f * 100).round
	end

	def disliked
		(self.medium.disliked_count.to_f / self.medium.watched_count.to_f * 100).round
	end

end
