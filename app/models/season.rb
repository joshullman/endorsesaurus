class Season < ActiveRecord::Base
	belongs_to :show
	belongs_to :medium
	has_many   :episodes

	def watch(user, value)
		self.episodes.each do |episode|
			episode.watch(user, value)
		end
	end

	# def update_likes(user, value)
	#   self.episodes.each do |episode|
 #      like = Like.where(user_id: user.id, medium_id: episode.medium.id).first
 #      if like
	#      episode.update_like(user, value)
	#     else
	#     	episode.like_and_distribute_points(user, value)
	#     end
 #    end
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

	# def distribute_points_for_recommendations(user, value)
	# 	medium_id = self.medium.id
	# 	recommendations = Recommendation.where(receiver_id: user, medium_id: medium_id)
 #    if !recommendations.empty? && value == 1
 #      recommendations.map do |rec|
 #      	user.update_points(self.points)
 #        rec.sender.update_points(self.points)
 #        Recommendation.find(rec.id).destroy
 #        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Season", medium_id: medium_id, notification_type: "liked rec")
 #      end
 #    elsif !recommendations.empty? && value == -1
 #      recommendations.map do |rec|
 #      	user.update_points(self.points)
 #        rec.sender.update_points(-self.points)
 #        Recommendation.find(rec.id).destroy
 #        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Season", medium_id: medium_id, notification_type: "disliked rec")
 #      end
 #    elsif !recommendations.empty? && value == 0
 #      recommendations.map do |rec|
 #      	user.update_points(self.points)
 #        Recommendation.find(rec.id).destroy
 #        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Season", medium_id: medium_id, notification_type: "seen rec")
 #      end
 #    end
	# end

end
