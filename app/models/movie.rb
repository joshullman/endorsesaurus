class Movie < ActiveRecord::Base
	belongs_to :medium

	# searchable do
	# 	text :title
	# end

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

	def watch(user, value)
		if like.where(user_id: user.id, medium_id: self.medium.id).first
			self.update_like(user, value)
		else
			self.like_and_distribute_points(user, value)
		end
	end

	def update_like(user, value)
		like = Like.where(user_id: user.id, medium_id: self.medium.id).first
		old_value = like.value
    like.value = value
    like.save
    self.medium.increment_likes(value)
    self.medium.decrement_likes(old_value)
	end

	def like_and_distribute_points(user, value)
		Like.create(user_id: user.id, medium_id: self.medium.id, media_type: "Movie", value: value)
    self.medium.increment_watches
		self.medium.increment_likes(value)
		medium_id = self.medium.id
		recommendations = Recommendation.where(receiver_id: user, medium_id: medium_id)
    if !recommendations.empty? && value == 1
      recommendations.map do |rec|
      	user.update_points(self.points)
        rec.sender.update_points(self.points)
        Recommendation.find(rec.id).destroy
        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Movie", medium_id: medium_id, notification_type: "liked rec")
      end
    elsif !recommendations.empty? && value == -1
      recommendations.map do |rec|
      	user.update_points(self.points)
        rec.sender.update_points(-self.points)
        Recommendation.find(rec.id).destroy
        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Movie", medium_id: medium_id, notification_type: "disliked rec")
      end
    elsif !recommendations.empty? && value == 0
      recommendations.map do |rec|
      	user.update_points(self.points)
        Recommendation.find(rec.id).destroy
        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Movie", medium_id: medium_id, notification_type: "seen rec")
      end
    end
	end
end
