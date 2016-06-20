class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])

    # @current_user_likes = current_user.user_likes

    @recent_activity = @user.recent_activity(20)
  end

  def movies
    @user = User.find(params[:id])
    @watched = organize_movie_likes(@user)
    @movie_recs = find_movie_recommendations(@user)
    @current_user_likes = current_user.movie_likes
    @user_likes = @user.movie_likes
    @likes = @watched[1]
    @seen = @watched[0]
    @dislikes = @watched[-1]
    @percents = movie_percents(@movie_recs)
  end

  def shows
    @user = User.find(params[:id])
    @watched = organize_show_likes
    @show_recs = find_show_recommendations
    @current_user_likes = current_user.show_likes
    @progress = find_user_progress(@user, @watched)
    @watched = @watched.sort_by {|show, season| @progress[show.medium_id]}.reverse.to_h
    @user_likes = @user.show_likes
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
      @media_points = @info.points
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

  def find_movie_recommendations(user)
    recs = []
    recommendations = user.received_recs.where(media_type: "Movie").group_by(&:medium_id)
    recommendations.each_value do |array|
      rec = MovieRec.new(array)
      rec.do_all_the_stuff
      recs << rec
    end
    recs.sort_by! {|rec| rec.user_points}.reverse!
  end

  def organize_movie_likes(user)
    likes_hash = {}
    likes = user.likes.where(media_type: "Movie").group_by(&:value)
    likes.each_key do |key|
      likes_hash[key] = []
      likes[key].each do |like|
        likes_hash[key] << like.find_associated_media
      end
    end
    likes_hash
  end

  def movie_percents(movie_recs)
    percents = {}
    movie_recs.each do |rec|
      percents[rec.info.medium_id] = rec.info.percents
    end
    percents
  end

  class EpRec
    attr_reader :rec_array, :rec_points, :media_points, :rec_by, :info
    def initialize(rec_array = [])
      @rec_array = rec_array
      @info = Medium.find(rec_array.first.medium_id).find_associated_media
      @media_points = @info.points
      @rec_points = 0
      @rec_by = []
    end

    def push_reccommenders
      @rec_array.each {|rec| @rec_by << rec.sender}
    end

    def determine_rec_points
      @rec_by.each {|user| @rec_points += user.points}
    end

    def rec_by_user?(user_id)
      @rec_by.any? {|rec| rec.id == user_id}
    end

    def do_all_the_stuff
      push_reccommenders
      determine_rec_points
    end

  end

  class SeasonRec
    attr_reader :ep_recs, :rec_points, :media_points, :rec_by, :info
    attr_writer :user
    def initialize(season, ep_recs = [])
      @user = nil
      @ep_recs = ep_recs
      @info = season
      @media_points = 0
      @rec_points = 0
      @rec_by = []
    end

    def push_reccommenders
      @ep_recs.each {|ep_rec| @rec_by << ep_rec.rec_by}
    end

    def determine_rec_points
      @ep_recs.each {|ep_rec| @rec_points += ep_rec.rec_points}
    end

    def determine_media_points
      @ep_recs.each {|ep_rec| @media_points += ep_rec.media_points}
    end

    def rec_by_user?(user_id)
      @rec_by.any? {|rec| rec.id == user_id}
    end

    def do_all_the_stuff
      push_reccommenders
      @rec_by.flatten!.uniq!
      @rec_by.delete_if {|recommender| !@info.recommended_to?(@user.id, recommender.id)}
      determine_rec_points
      determine_media_points
    end

  end

  class ShowRec
    attr_reader :season_recs, :rec_points, :media_points, :rec_by, :info
    attr_writer :user
    def initialize(show, season_recs = [])
      @user = nil
      @season_recs = season_recs.sort_by! {|show_rec| show_rec.rec_points}.reverse!
      @info = show
      @media_points = 0
      @rec_points = 0
      @rec_by = []
    end

    def push_reccommenders
      @season_recs.each {|season_rec| @rec_by << season_rec.rec_by}
    end

    def determine_rec_points
      @season_recs.each {|season_rec| @rec_points += season_rec.rec_points}
    end

    def determine_media_points
      @season_recs.each {|season_rec| @media_points += season_rec.media_points}
    end

    def rec_by_user?(user_id)
      @rec_by.any? {|rec| rec.id == user_id}
    end

    def do_all_the_stuff
      push_reccommenders
      @rec_by.flatten!.uniq!
      @rec_by.delete_if {|recommender| !@info.recommended_to?(@user.id, recommender.id)}
      determine_rec_points
      determine_media_points
    end

  end

  def find_show_recommendations
    recs = []
    recommendations = @user.received_recs.where(media_type: "Episode").group_by(&:medium_id)
    recommendations.each_value do |array|
      rec = EpRec.new(array)
      rec.do_all_the_stuff
      recs << rec
    end

    org_season_recs = recs.group_by {|rec| rec.info.season_id}
    season_recs = []
    org_season_recs.each do |season_id, ep_recs|
      season = Season.find(season_id)
      season_rec = SeasonRec.new(season, ep_recs)
      season_rec.user = @user
      season_rec.do_all_the_stuff
      season_recs << season_rec
    end

    p season_recs.first

    org_show_recs = season_recs.group_by {|rec| rec.info.show_id}
    show_recs = []
    org_show_recs.each do |show_id, season_recs|
      show = Show.find(show_id)
      show_rec = ShowRec.new(show, season_recs)
      show_rec.user = @user
      show_rec.do_all_the_stuff
      show_recs << show_rec
    end
    show_recs.sort_by! {|show_rec| show_rec.rec_points}.reverse!

    # recs.sort_by! {|rec| rec.user_points}.reverse!
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
      likes_hash[episode.show] = likes_hash[episode.show].sort.to_h
      likes_hash[episode.show][episode.season] = likes_hash[episode.show][episode.season].sort_by {|x| x.episode_num}
    end
    likes_hash
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
    progress = progress.sort_by {|percents| percents[1][0]}.reverse.to_h
  end


end
