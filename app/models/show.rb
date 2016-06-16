class Show < ActiveRecord::Base
	belongs_to  :medium
	has_many    :seasons
	has_many    :episodes

	# searchable do
	# 	text :title
	# end

	def watch(user, value)
		self.seasons.each do |season|
			season.watch(user, value)
		end
	end

	# def update_likes(user, value)
 #    self.seasons.each do |season|
 #    	season.update_likes(user, value)
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

end