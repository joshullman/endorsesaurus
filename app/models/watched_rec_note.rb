class WatchedRecNote < ActiveRecord::Base
	belongs_to :user_one, class_name: "User"
	belongs_to :user_two, class_name: "User"

	def sender
		User.find(self.sender_id)
	end

	def receiver
		User.find(self.receiver_id)
	end
end
