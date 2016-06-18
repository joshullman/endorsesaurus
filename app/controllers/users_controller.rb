class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])

    @current_user_likes = current_user.user_likes

    @recent_activity = @user.recent_activity(20)
  end

  def movies
    do_even_more_stuff("Movie")
  end

  def shows
    do_even_more_stuff("Episode")
  end

  def friends
    @user = User.find(params[:id])
  end

  def current_user_home
    redirect_to dashboard_user_path(current_user)
  end

  def dashboard
    if params[:id].to_i != current_user.id
      redirect_to dashboard_user_path(current_user)
    else
      @user = current_user

      @friends_recents = current_user.friends_recent_activity
    end
  end

  private

  class MovieRec
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

  class ShowRec
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

  def organize_movie_likes
    likes_hash = {}
    likes = @user.likes.where(media_type: "Movie").group_by(&:value)
    likes.each_key do |key|
      likes_hash[key] = []
      likes[key].each do |like|
        likes_hash[key] << like.find_associated_media
      end
    end
    likes_hash
  end

  def organize_show_likes
    likes_hash = {}
    likes = @user.likes.where(media_type: "Episode")
    likes.each do |like|
        episode = like.find_associated_media
        if !likes_hash[episode.show]
          likes_hash[episode.show] = {}
        end
        if !likes_hash[episode.show][episode.season]
          likes_hash[episode.show][episode.season] = []
        end
        likes_hash[episode.show][episode.season] << episode
      end
    likes_hash
  end

  def find_movie_recommendations
    recs = []
    recommendations = @user.received_recs.where(media_type: "Movie").group_by(&:medium_id)
    recommendations.each_value do |array|
      rec = MovieRec.new(array)
      rec.do_all_the_stuff
      recs << rec
    end
    recs.sort_by! {|rec| rec.user_points}.reverse!
  end

  def find_show_recommendations
    recs = []
    recommendations = @user.received_recs.where(media_type: "Episode")
    recommendations.each_value do |array|
      rec = ShowRec.new(array)
      rec.do_all_the_stuff
      recs << rec
    end
    recs.sort_by! {|rec| rec.user_points}.reverse!
  end

  def find_recently_watched(media_type, num)
    recently_watched = {}
    recents = @user.likes.where(media_type: media_type).last(num).reverse
    recents.each do |like|
      recently_watched[like.find_associated_media] = like.value
    end
    recently_watched
  end

  def find_user_progress(user, likes)
    progress = {}
    likes.each do |show, seasons|
      progress[show.medium_id] = user.show_progress(show)
      seasons.each do |season, episodes|
        progress[season.medium_id] = user.season_progress(season)
      end
    end
    progress
  end

  def organize_recs(likes, recs)
  end

  def do_even_more_stuff(media_type)
    # Profile information
    @user = User.find(params[:id])
    # finding the media assosciated with Likes
    media_type == "Movie" ? @likes = organize_movie_likes : @likes = organize_show_likes
    media_type == "Movie" ? @recs = find_movie_recommendations : @recs = find_show_recommendations
    # finding recently watched
    # @recently_watched = find_recently_watched(media_type, 5)
    #current_user information
    @current_user_likes = current_user.user_likes
    if media_type == "Episode"
      @progress = find_user_progress(@user, @likes)
    end

    # @recs = organize_recs(@likes, @recs)
    
    if media_type == "Movie"
      @dislikes = @likes[-1]
      @seens = @likes[0]
      @likes = @likes[1]
    end

    @user_likes = @user.user_likes

  end

end
