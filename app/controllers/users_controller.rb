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
    do_even_more_stuff("Season")
    p @likes
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

  def organize_likes(media_type)
    likes_hash = {}
    likes = @user.likes.where(media_type: media_type).group_by(&:value)
    likes.each_key do |key|
      likes_hash[key] = []
      likes[key].each do |like|
        likes_hash[key] << like.find_associated_media
      end
      # p likes_hash
      # if media_type == "Season"
      #   likes_hash[key] = likes_hash[key].group_by {|season| season.show_id }
      #   # likes_hash[key].each do |hash|
      #   #   likes_hash[key][Show.find(hash.key)] = likes_hash[key][hash.value]
      #   #   likes_hash[key][hash.key].delete
      #   # end
      # end
    end
    likes_hash
  end

  def find_recommendations(media_type)
    recs = []
    recommendations = @user.received_recs.where(media_type: media_type).group_by(&:medium_id)
    recommendations.each_value do |array|
      rec = Rec.new(array)
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

  def do_even_more_stuff(media_type)
    # Profile information
    @user = User.find(params[:id])
    @recs = find_recommendations(media_type)
    # finding the media assosciated with Likes
    @likes = organize_likes(media_type)
    # finding recently watched
    @recently_watched = find_recently_watched(media_type, 5)
    #current_user information
    @current_user_likes = current_user.user_likes
    
    @user_likes = @user.user_likes

  end

end
