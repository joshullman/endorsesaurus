class Season < ActiveRecord::Base
	belongs_to :show
	belongs_to :medium
	has_many   :episodes

	def watch(user, value)
		self.episodes.each do |episode|
			episode.watch(user, value)
		end
	end

	def recommended_to?(receiver, sender)
		total_count = self.episodes.count
		count = 0
		self.episodes.each do |episode|
			count += 1 if episode.recommended_to?(receiver, sender)
	  end
	  total_count == count
  end

	def recommend_to(receivers, sender)
		self.episodes.each do |episode|
			episode.recommend_to(receivers, sender)
		end
	end

	def unrecommend_to(receiver, sender)
		self.episodes.each do |episode|
			episode.unrecommend_to(reciever, sender)
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
