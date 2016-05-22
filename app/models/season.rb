class Season < ActiveRecord::Base
	belongs_to :show
	belongs_to :medium
	has_many   :episodes


	def watch_all(value)
		Like.create(user_id: current_user.id, medium_id: self.medium.id, value: value)
		self.episodes.each do |episode|
			episode.medium.increment_watches
			self.medium.increment_watches
			self.show.medium.increment_watches
			episode.medium.increment_likes(value)
			self.medium.increment_likes(value)
			self.show.medium.increment_likes(value)
			Like.create(user_id: current_user.id, medium_id: episode.medium.id, value: value)
		end
		case value
			when 1
				Notification.create(user_one_id: current_user.id, medium_id: self.medium.id, notification_type: "like")
			when 0
				Notification.create(user_one_id: current_user.id, medium_id: self.medium.id, notification_type: "seen")
			when -1
				Notification.create(user_one_id: current_user.id, medium_id: self.medium.id, notification_type: "dislike")
		end
	end

end
