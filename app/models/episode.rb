class Episode < ActiveRecord::Base
	belongs_to :medium
	belongs_to :season
	belongs_to :show

  def watch(user, value)
    if Like.where(user_id: user.id, medium_id: self.medium.id).first
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
    self.season.medium.increment_likes(value)
    self.show.medium.increment_likes(value)
    self.medium.decrement_likes(old_value)
    self.season.medium.decrement_likes(old_value)
    self.show.medium.decrement_likes(old_value)
	end

	def like_and_distribute_points(user, value)
		Like.create(user_id: user.id, medium_id: self.medium.id, media_type: "Episode", value: value)
    self.medium.increment_watches
    self.season.medium.increment_watches
    self.show.medium.increment_watches
		self.medium.increment_likes(value)
    self.season.medium.increment_likes(value)
    self.show.medium.increment_likes(value)
    medium_id = self.medium.id
		recommendations = Recommendation.where(receiver_id: user, medium_id: medium_id)
    if !recommendations.empty? && value == 1
      recommendations.map do |rec|
      	user.update_points(self.points)
        rec.sender.update_points(self.points)
        Recommendation.find(rec.id).destroy
        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Episode", medium_id: medium_id, notification_type: "liked rec")
      end
    elsif !recommendations.empty? && value == -1
      recommendations.map do |rec|
      	user.update_points(self.points)
        rec.sender.update_points(-self.points)
        Recommendation.find(rec.id).destroy
        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Episode", medium_id: medium_id, notification_type: "disliked rec")
      end
    elsif !recommendations.empty? && value == 0
      recommendations.map do |rec|
      	user.update_points(self.points)
        Recommendation.find(rec.id).destroy
        Notification.create(user_one_id: rec.sender.id, user_two_id: user.id, media_type: "Episode", medium_id: medium_id, notification_type: "seen rec")
      end
    end
	end
end
