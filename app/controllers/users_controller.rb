class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])

    @current_user_likes = current_user.user_likes

    @recent_activity = recent_activity
    @recent_activity.reverse!
  end

  def movies
    do_even_more_stuff("movie")
  end

  def shows
    do_even_more_stuff("series")
  end

  def friends
    @user = User.find(params[:id])
  end

  def current_user_home
    redirect_to dashboard_user_path(current_user)
  end

  def dashboard
    if Integer(params[:id]) != current_user.id
      redirect_to dashboard_user_path(current_user)
    else
      @user = current_user
      @recent_activity = @user.notifications.last(10)

      @recents = friends_recent_activity
      @friends_recents = @recents.reverse!
    end
  end

  private

  class Rec
    attr_reader :rec_array, :user_points, :media_points, :rec_by, :info
    def initialize(rec_array = [])
      @rec_array = rec_array
      @info = Medium.find(rec_array.first.medium_id).find_associated_media
      @media_points = 0
      @user_points = 0
      @rec_by = []
    end

    def push_reccommenders
      @rec_array.each {|rec| @rec_by << rec.sender}
    end

    def determine_user_points
      @rec_by.each {|user| @user_points += user.points}
    end

    def rec_by_user?(user_id)
      @rec_by.any? {|rec| rec.id == user_id}
    end

    def do_all_the_stuff
      push_reccommenders
      determine_user_points
    end

  end

  class Note
    attr_reader :user_one, :user_two, :media_type, :notification_type, :media, :points, :created_at
    def initialize(notification)
      @notification = notification
      @user_one = notification.user_one
      @user_two = notification.user_two
      @notification_type = notification.notification_type
      @note_created_at = notification.created_at
    end

    def do_stuff
      if @notification_type != "friends"
        @medium = Medium.find(@notification.medium_id)
        @media_type = @medium.media_type
        @media = @medium.find_associated_media
        @points = @media.points
      end
    end

  end

  def organize_likes(media_type)
  likes_hash = {}
  likes = Like.where(user_id: @user.id).group_by(&:value)
  likes.each_key do |key|
    likes_hash[key] = []
    likes[key].each do |like|
      case media_type
        when "movie"
          likes_hash[key] << like.find_associated_media if like.medium.media_type == "Movie"
        when "series"
          likes_hash[key] << like.find_associated_media if like.medium.media_type == "Season"
      end
    end
  end
  likes_hash
  end

  def find_recommendations(media_type, instance_recs)
    recommendations = Recommendation.where(receiver_id: @user.id).group_by(&:medium_id)
    recommendations.each_value do |array|
      rec = Rec.new(array)
      rec.do_all_the_stuff
      medium_type = rec.info.medium.media_type
      case media_type
      when "movie"
        instance_recs << rec if rec.info.medium.media_type == "Movie"
      when "series"
        instance_recs << rec if rec.info.medium.media_type == "Season"
      end
    end
    instance_recs.sort_by! {|rec| rec.user_points}.reverse!
  end

  def find_recently_watched(media_type, num)
    recently_watched = {}
    recents = Like.where(user_id: @user.id).last(num).reverse

    recents.each do |like|
      case media_type
        when "movie"
          recently_watched[like.find_associated_media] = like.value if like.medium.media_type == "Movie"
        when "series"
          recently_watched[like.find_associated_media] = like.value if like.medium.media_type == "Season"
      end
    end
    recently_watched
  end

  def recent_activity
    activity = []
    notifications = @user.notifications
    notifications.each do |notification|
      note = Note.new(notification)
      note.do_stuff
      activity << note
    end
    activity
  end

  def do_even_more_stuff(media_type)
    # Profile information
    @user = User.find(params[:id])
    @recs = []
    find_recommendations(media_type, @recs)
    # finding the media assosciated with Likes
    @likes = organize_likes(media_type)
    # finding recently watched
    @recently_watched = find_recently_watched(media_type, 5)
    #current_user information
    @current_user_likes = current_user.user_likes
    
    @user_likes = @user.user_likes

  end

  def friends_recent_activity
    activity = []
    @user.friends.each do |friend|
      activity << friend.recent_activity
    end
    activity
  end

end
