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

	def distribute_points_for_recommendations(user, value)
		Like.create(user_id: user.id, medium_id: self.medium.id, media_type: "Movie", value: value)
    self.medium.increment_watches
    user.update_points(self.points)
		medium_id = self.medium.id
		self.medium.increment_likes(value)
		recommendations = Recommendation.where(receiver_id: user, medium_id: medium_id)
    if !recommendations.empty? && value == 1
      recommendations.map do |rec|
        rec.sender.update_points(self.points)
        Recommendation.find(rec.id).destroy
        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Movie", medium_id: medium_id, notification_type: "liked rec")
      end
    elsif !recommendations.empty? && value == -1
      recommendations.map do |rec|
        rec.sender.update_points(-self.points)
        Recommendation.find(rec.id).destroy
        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Movie", medium_id: medium_id, notification_type: "disliked rec")
      end
    elsif !recommendations.empty? && value == 0
      recommendations.map do |rec|
        Recommendation.find(rec.id).destroy
        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Movie", medium_id: medium_id, notification_type: "seen rec")
      end
    end
	end
end
