class Show < ActiveRecord::Base
	belongs_to :medium
	has_many   :seasons

	def watch_all(value)
		Like.create(user_id: current_user.id, medium_id: self.medium.id, value: value)
		self.seasons.each do |season|
			Like.create(user_id: current_user.id, medium_id: season.medium.id, value: value)
			season.watch_all(value)
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