class Episode < ActiveRecord::Base
	belongs_to :medium
	belongs_to :season
	belongs_to :show

  def watch(user, value, note = true)
    if Like.where(user_id: user.id, medium_id: self.medium_id).empty?
      self.like_and_distribute_points(user, value, note)
    else
      self.update_like(user, value)
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
    WatchedNote.where(user_id: user.id, medium_id: self.medium.id).first.destroy
    WatchedNote.create(user_id: user.id, medium_id: self.medium.id, media_type: "Episode", value: value)
	end

	def like_and_distribute_points(user, value, note = true)
		Like.create(user_id: user.id, medium_id: self.medium_id, media_type: "Episode", value: value)
    WatchedNote.create(user_id: user.id, medium_id: self.medium.id, media_type: "Episode", value: value)
    self.medium.increment_watches
    self.season.medium.increment_watches
    self.show.medium.increment_watches
		self.medium.increment_likes(value)
    self.season.medium.increment_likes(value)
    self.show.medium.increment_likes(value)
    self.distribute_points(user, value, note)
	end

  def distribute_points(user, value, note = true)
    medium_id = self.medium.id
    recommendations = Recommendation.where(receiver_id: user.id, medium_id: medium_id)
    if !recommendations.empty?
      user.update_points(self.points)
      case value
        when 1
          recommendations.each do |rec|
            rec.sender.update_points(self.points)
            Recommendation.find(rec.id).destroy
            WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Episode", medium_id: medium_id, value: value) if note
          end
        when -1
          recommendations.each do |rec|
            rec.sender.update_points(-self.points)
            Recommendation.find(rec.id).destroy
            WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Episode", medium_id: medium_id, value: value) if note
          end
        when 0
          recommendations.each do |rec|
            Recommendation.find(rec.id).destroy
            WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Episode", medium_id: medium_id, value: value) if note
          end
      end
    end
  end

  def recommended_to?(receiver, sender)
    !Like.where(user_id: receiver, medium_id: self.medium_id).empty? || !Recommendation.where(sender_id: sender, receiver_id: receiver, medium_id: self.medium_id).empty?
  end

  def recommend_to(receivers, sender, note = true)
    receivers.each do |receiver|
      if !self.recommended_to?(receiver, sender)
        self.medium.increment_recommends
        self.season.medium.increment_recommends
        self.show.medium.increment_recommends
        Recommendation.create(sender_id: sender, receiver_id: receiver, media_type: "Episode", medium_id: self.medium_id)
        RecNote.create(sender_id: sender, receiver_id: receiver, media_type: "Episode", medium_id: self.medium_id) if note
      end
    end
  end

  def unrecommend_to(receiver, sender)
    rec = Recommendation.where(sender_id: sender, receiver_id: receiver, media_type: "Episode", medium_id: self.medium_id).first
    if rec
      RecNote.where(sender_id: sender, receiver_id: receiver, media_type: "Episode", medium_id: self.medium_id).first.destroy
      rec.destroy
      self.medium.decrement_recommends
      self.season.medium.decrement_recommends
      self.show.medium.decrement_recommends
    end
  end
end
