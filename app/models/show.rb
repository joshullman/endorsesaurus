class Show < ActiveRecord::Base
	belongs_to :medium
	has_many   :seasons

	searchable do
		text :title
	end

	def watch_all(user, value)
		Like.create(user_id: user.id, medium_id: self.medium.id, value: value)
		self.seasons.each do |season|
			season.watch_all(user, value)
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
    self.seasons.each do |season|
    	season.update_likes(user, value)
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

	def percents
		medium = self.medium
		if medium.watched_count != 0
			liked = (medium.liked_count.to_f / medium.watched_count.to_f * 100.0).round
			seen = (medium.seen_count.to_f / medium.watched_count.to_f * 100.0).round
			disliked = (medium.disliked_count.to_f / medium.watched_count.to_f * 100.0).round
			percents = [liked, seen, disliked]
			if liked + seen + disliked > 100
				random = rand(3)
				until percents[random] != 0
					random = rand(3)
				end
				percents[random] = percents[random] - 1
			elsif liked + seen + disliked < 100
				random = rand(3)
				until percents[random] != 0
					random = rand(3)
				end
				percents[random] = percents[random] + 1
			end
		else
			percents = [0, 0, 0]
		end
		percents
	end

end