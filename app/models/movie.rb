class Movie < ActiveRecord::Base
	belongs_to :medium

	searchable do
		text :title
	end

	def percent
		liked = (self.medium.liked_count.to_f / self.medium.watched_count.to_f * 100.0).round
		seen = (self.medium.seen_count.to_f / self.medium.watched_count.to_f * 100.0).round
		disliked = (self.medium.disliked_count.to_f / self.medium.watched_count.to_f * 100.0).round
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
		{self.id => percents}
	end
end
