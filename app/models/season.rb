class Season < ActiveRecord::Base
	belongs_to :show
	belongs_to :medium
	has_many   :episodes

	def watch_all(user, value, recommendation = false)
		self.episodes.each do |episode|
			episode.medium.increment_watches
			self.medium.increment_watches
			self.show.medium.increment_watches
			episode.medium.increment_likes(value)
			self.medium.increment_likes(value)
			self.show.medium.increment_likes(value)
			if !Like.where(user_id: user.id, medium_id: episode.medium.id).first
				Like.create(user_id: user.id, medium_id: episode.medium.id, media_type: "Episode", value: value) 
			else
				like = Like.where(user_id: user.id, medium_id: episode.medium.id).first
				old_value = like.value
				like.value = value
				like.save
				episode.medium.increment_likes(value)
		    episode.medium.decrement_likes(old_value)
			end
		end
		self.distribute_points_for_recommendations(user, value) if recommendation
	end

	def update_likes(user, value)
	  self.episodes.each do |episode|
      like = Like.where(user_id: user.id, medium_id: episode.medium.id).first
      old_value = like.value
      like.value = value
      like.save
      episode.medium.increment_likes(value)
      episode.medium.decrement_likes(old_value)
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

	def distribute_points_for_recommendations(user, value)
		medium_id = self.medium.id
		user.update_points(self.points)
		recommendations = Recommendation.where(receiver_id: user, medium_id: medium_id)
    if !recommendations.empty? && value == 1
      recommendations.map do |rec|
        rec.sender.update_points(self.points)
        Recommendation.find(rec.id).destroy
        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Season", medium_id: medium_id, notification_type: "liked rec")
      end
    elsif !recommendations.empty? && value == -1
      recommendations.map do |rec|
        rec.sender.update_points(-self.points)
        Recommendation.find(rec.id).destroy
        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Season", medium_id: medium_id, notification_type: "disliked rec")
      end
    elsif !recommendations.empty? && value == 0
      recommendations.map do |rec|
        Recommendation.find(rec.id).destroy
        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Season", medium_id: medium_id, notification_type: "seen rec")
      end
    end
	end

end
