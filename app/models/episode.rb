class Episode < ActiveRecord::Base
	belongs_to :medium
	belongs_to :season
	belongs_to :show

  def watch(user, value)
    if Like.where(user_id: user.id, medium_id: self.medium_id).first
      self.update_like(user, value)
    else
      self.like_and_distribute_points(user, value)
    end
  end

	def update_like(user, value)
		like = Like.where(user_id: user.id, medium_id: self.medium_id).first
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
		Like.create(user_id: user.id, medium_id: self.medium_id, media_type: "Episode", value: value)
    self.medium.increment_watches
    self.season.medium.increment_watches
    self.show.medium.increment_watches
		self.medium.increment_likes(value)
    self.season.medium.increment_likes(value)
    self.show.medium.increment_likes(value)
    self.distribute_points(user, value)
	end

  def distribute_points(receiver, value)
    medium_id = self.medium.id
    recommendations = Recommendation.where(receiver_id: receiver.id, medium_id: medium_id)
    if !recommendations.empty?
      receiver.update_points(self.points)
      case value
        when 1
          recommendations.each do |rec|
            rec.sender.update_points(self.points)
            Recommendation.find(rec.id).destroy
            Notification.create(user_one_id: rec.sender.id, user_two_id: receiver.id, media_type: "Episode", medium_id: medium_id, notification_type: "liked rec")
          end
        when -1
          recommendations.each do |rec|
            rec.sender.update_points(-self.points)
            Recommendation.find(rec.id).destroy
            Notification.create(user_one_id: rec.sender.id, user_two_id: receiver.id, media_type: "Episode", medium_id: medium_id, notification_type: "disliked rec")
          end
        when 0
          recommendations.each do |rec|
            Recommendation.find(rec.id).destroy
            Notification.create(user_one_id: rec.sender.id, user_two_id: receiver.id, media_type: "Episode", medium_id: medium_id, notification_type: "seen rec")
          end
      end
    end
  end

  def recommended_to?(receiver, sender)
    Like.where(user_id: receiver, medium_id: self.medium_id).first || Recommendation.where(sender_id: sender, receiver_id: receiver, medium_id: self.medium_id).first
  end

  def recommend_to(receivers, sender)
    receivers.each do |receiver|
      if !self.recommended_to?(receiver, sender)
        self.medium.increment_recommends
        self.season.medium.increment_recommends
        self.show.medium.increment_recommends
        Recommendation.create(sender_id: sender, receiver_id: receiver, media_type: "Episode", medium_id: self.medium_id)
      end
    end
  end

  def unrecommend_to(receiver, sender)
    rec = Recommendation.where(sender_id: sender, receiver_id: receiver, media_type: "Episode", medium_id: self.medium_id).first
    if rec
      rec.destroy
      self.medium.decrement_recommends
      self.season.medium.decrement_recommends
      self.show.medium.decrement_recommends
    end
  end
end
