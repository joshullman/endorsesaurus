class User < ActiveRecord::Base
	has_many :sent_recs, class_name: "Recommendation", source: :user_one, foreign_key: "sender_id"
	has_many :received_recs, class_name: "Recommendation", source: :user_two, foreign_key: "receiver_id"

  has_many :sent_notifications, class_name: "Notification", source: :user_one, foreign_key: "user_one_id"
  has_many :received_notifications, class_name: "Notification", source: :user_two, foreign_key: "user_two_id"

  def notifications
    (sent_notifications | received_notifications).sort!
  end

	has_many :likes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def has_recommended_to?(id, medium_id)
    Recommendation.where(sender_id: self.id, receiver_id: id, medium_id: medium_id).first == nil ? false : true
  end

  def recent_activity
    Notification.where(user_one_id: self.id).order(created_at: :desc)
  end

  def update_points(points)
    self.points = self.points + points
    self.points = 0 if self.points < 0
    self.save
  end

  def user_likes
    likes = {}
    user_likes = Like.where(user_id: self.id)
    user_likes.each do |like|
      likes[Medium.find(like.medium_id).id] = like.value
    end
    likes
  end

  def recent_activity
    activities = []
    notifications = self.notifications
    notifications.each do |notification|
      note = Note.new(notification)
      note.do_stuff
      activities << note
    end
    activities.reverse!
  end

  def friends_recent_activity
    activities = []
    self.friends.each do |friend|
      activities << friend.recent_activity
    end
    activities.flatten.sort {|x, y| y.created_at <=> x.created_at }
  end

  def watched_all_episodes?(season_id)
    episodes = Episode.where(season_id: season_id)
    medium_ids = []
    episodes.each do |episode|
      medium_ids << episode.medium.id
    end

    liked_count = 0
    seen_count = 0
    disliked_count = 0
    medium_ids.each do |id|
      like = Like.where(user_id: self.id, medium_id: id).first
      if like
        case like.value
        when 1
          liked_count += 1
        when 0
          seen_count += 1
        when -1
          disliked_count += 1
        end
      end
    end
    watched_all = nil
    value = nil
    (liked_count + seen_count + disliked_count == episodes.count) ? watched_all = true : watched_all = false
    value = 1 if liked_count == episodes.count
    value = 0 if seen_count == episodes.count
    value = -1 if disliked_count == episodes.count
    [watched_all, value]
  end

  def watched_all_seasons?(show_id)
    seasons = Season.where(show_id: show_id)
    medium_ids = []
    seasons.each do |episode|
      medium_ids << episode.medium.id
    end

    liked_count = 0
    seen_count = 0
    disliked_count = 0
    medium_ids.each do |id|
      like = Like.where(user_id: self.id, medium_id: id).first
      if like
        case like.value
        when 1
          liked_count += 1
        when 0
          seen_count += 1
        when -1
          disliked_count += 1
        end
      end
    end
    watched_all = nil
    value = nil
    (liked_count + seen_count + disliked_count == seasons.count) ? watched_all = true : watched_all = false
    value = 1 if liked_count == seasons.count
    value = 0 if seen_count == seasons.count
    value = -1 if disliked_count == seasons.count
    [watched_all, value]
  end

  def already_recommended_show_to?(user, show_id)
    show = Show.find(show_id)
    medium_ids = []
    show.seasons.each do |season|
      medium_ids << season.medium.id
    end
    recs = self.received_recs

    season_count = 0
    medium_ids.each do |id|
      season_count += 1 if Recommendation.where(sender_id: user.id, receiver_id: self.id, medium_id: id).first
    end

    season_count == show.seasons.count
  end

  # FRIENDS

  has_many :friendships
  has_many :passive_friendships, :class_name => "Friendship", :foreign_key => "friend_id"

  has_many :active_friends, -> { where(friendships: { accepted: true}) }, :through => :friendships, :source => :friend
  has_many :passive_friends, -> { where(friendships: { accepted: true}) }, :through => :passive_friendships, :source => :user
  has_many :pending_friends, -> { where(friendships: { accepted: false}) }, :through => :friendships, :source => :friend
  has_many :requested_friendships, -> { where(friendships: { accepted: false}) }, :through => :passive_friendships, :source => :user


  def friends
    active_friends | passive_friends
  end

  # OMNIAUTH

  devise :omniauthable, :omniauth_providers => [:facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.email = auth.info.email   # assuming the user model has a name
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  private

  class Note
    attr_reader :user_one, :user_two, :media_type, :notification_type, :media, :points, :created_at
    def initialize(notification)
      @notification = notification
      @user_one = notification.user_one
      @user_two = notification.user_two
      @notification_type = notification.notification_type
      @created_at = notification.created_at
    end

    def do_stuff
      if @notification_type != "friends"
        @medium = Medium.find(@notification.medium_id)
        @media_type = @medium.media_type
        @media = @medium.find_associated_media
        p @media
        @points = @media.points
      end
    end

  end
end
