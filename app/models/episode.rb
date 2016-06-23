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
    note = WatchedNote.where(user_id: user.id, medium_id: self.medium_id).first
    note.destroy if note
    WatchedNote.create(user_id: user.id, medium_id: self.medium_id, media_type: "Episode", value: value)
	end

	def like_and_distribute_points(user, value, note = true)
		Like.create(user_id: user.id, medium_id: self.medium_id, media_type: "Episode", value: value)
    WatchedNote.create(user_id: user.id, medium_id: self.medium.id, media_type: "Episode", value: value) if note
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
            if note
              if rec.sender.recommended_show_to?(user.id, self.show_id)
                rec.sender.update_points(self.show.points)
                WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Show", medium_id: self.show_id, value: value, points: self.show.points)
                self.destroy_show_recommendations(rec.sender, user)
              elsif rec.sender.recommended_season_to?(user.id, self.season_id)
                rec.sender.update_points(self.season.points)
                WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Season", medium_id: self.season_id, value: value, points: self.season.points)
                self.destroy_season_recommendations(rec.sender, user)
              else
                rec.sender.update_points(self.points)
                WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Episode", medium_id: medium_id, value: value, points: self.points)
                Recommendation.find(rec.id).destroy
              end
            else
              rec.sender.update_points(self.points)
              WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Episode", medium_id: medium_id, value: value, points: self.points)
              Recommendation.find(rec.id).destroy
            end
          end
        when -1
          recommendations.each do |rec|
            if note
              if rec.sender.recommended_show_to?(user.id, self.show_id)
                rec.sender.update_points(self.show.points)
                WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Show", medium_id: self.show_id, value: value, points: self.show.points)
                self.destroy_show_recommendations(rec.sender, user)
              elsif rec.sender.recommended_season_to?(user.id, self.season_id)
                rec.sender.update_points(self.season.points)
                WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Season", medium_id: self.season_id, value: value, points: self.season.points)
                self.destroy_season_recommendations(rec.sender, user)
              else
                rec.sender.update_points(-self.points)
                WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Episode", medium_id: medium_id, value: value, points: self.points)
                Recommendation.find(rec.id).destroy
              end
            else
              rec.sender.update_points(-self.points)
              WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Episode", medium_id: medium_id, value: value, points: self.points)
              Recommendation.find(rec.id).destroy
            end
          end
        when 0
          recommendations.each do |rec|
            if note
              if rec.sender.recommended_show_to?(user.id, self.show_id)
                rec.sender.update_points(self.show.points)
                WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Show", medium_id: self.show_id, value: value, points: 0)
                self.destroy_show_recommendations(rec.sender, user)
              elsif rec.sender.recommended_season_to?(user.id, self.season_id)
                rec.sender.update_points(self.season.points)
                WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Season", medium_id: self.season_id, value: value, points: 0)
                self.destroy_season_recommendations(rec.sender, user)
              else
                WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Episode", medium_id: medium_id, value: value, points: 0)
                Recommendation.find(rec.id).destroy
              end
            else
              WatchedRecNote.create(sender_id: rec.sender.id, receiver_id: user.id, media_type: "Episode", medium_id: medium_id, value: value, points: 0)
              Recommendation.find(rec.id).destroy
            end
          end
      end
    end
  end

  def destroy_show_recommendations(sender, receiver)
    medium_ids = []
    self.show.episodes.each do |episode|
      medium_ids << episode.medium_id
    end
    medium_ids.each do |id|
      Recommendation.where(receiver_id: receiver.id, sender_id: sender.id, medium_id: id).first.destroy
    end
  end

  def destroy_season_recommendations(sender, receiver)
    medium_ids = []
    self.season.episodes.each do |episode|
      medium_ids << episode.medium_id
    end
    medium_ids.each do |id|
      Recommendation.where(receiver_id: receiver.id, sender_id: sender.id, medium_id: id).first.destroy
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
      note = RecNote.where(sender_id: sender, receiver_id: receiver, media_type: "Episode", medium_id: self.medium_id).first
      note.destroy if note
      rec.destroy
      self.medium.decrement_recommends
      self.season.medium.decrement_recommends
      self.show.medium.decrement_recommends
    end
  end
end
