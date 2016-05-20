class Season < ActiveRecord::Base
	belongs_to :show
	belongs_to :medium
	has_many   :episodes

	def watch_all(value)
		Like.create(user_id: current_user.id, medium_id: self.medium.id, value: value)
		self.episodes.each do |episode|
			Like.create(user_id: current_user.id, medium_id: episode.medium.id, value: value)
		end
		case value
			when 1
				Notification.create(user_id: current_user.id, medium_id: self.medium.id, notification_type: "like")
			when 0
				Notification.create(user_id: current_user.id, medium_id: self.medium.id, notification_type: "seen")
			when -1
				Notification.create(user_id: current_user.id, medium_id: self.medium.id, notification_type: "dislike")
		end
	end

end
