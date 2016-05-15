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

def organize_likes(media_type, instance_likes)
likes = Like.where(user_id: @user.id).group_by(&:value)
  likes.each_key do |key|
    instance_likes[key] = []
    likes[key].each do |like|
      case media_type
        when "movie"
          instance_likes[key] << like.find_associated_media if like.medium.media_type == "Movie"
        when "series"
          instance_likes[key] << like.find_associated_media if like.medium.media_type == "Season"
      end
    end
  end
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

def find_recently_watched(media_type, instance_likes, num)
  recents = Like.where(user_id: @user.id).last(num).reverse

  recents.each do |like|
    case media_type
      when "movie"
        instance_likes[like.find_associated_media] = like.value if like.medium.media_type == "Movie"
      when "series"
        instance_likes[like.find_associated_media] = like.value if like.medium.media_type == "Season"
    end
  end
end

def current_user_likes(instance_likes)
  current_user_likes = Like.where(user_id: current_user.id)
  current_user_likes.each do |like|
    instance_likes[Medium.find(like.medium_id).id] = like.value
  end
end

def user_likes(instance_likes, user)
  user_likes = Like.where(user_id: user.id)
  user_likes.each do |like|
    instance_likes[Medium.find(like.medium_id).id] = like.value
  end
end

def recent_activity(instance_activity)
  activity = []
  activity << @user.likes
  activity << @user.sent_recs
  activity << @user.received_recs
  activity.flatten!.sort_by! {|record| record.created_at}.reverse!
  activity.each do |record|
    if record.has_attribute?(:value)
      instance_activity[record.find_associated_media] = ["Like", record.value]
    elsif record.sender_id == @user.id
      instance_activity[record.find_associated_media] = ["R-To", record.receiver]
    else
      instance_activity[record.find_associated_media] = ["R-From", record.sender]
    end
  end
end

def do_even_more_stuff(media_type)
  # Profile information
  @user = User.find(params[:id])
  @recs = []
  find_recommendations(media_type, @recs)
  # finding the media assosciated with Likes
  @likes = {}
  organize_likes(media_type, @likes)
  # finding recently watched
  @recently_watched = {}
  find_recently_watched(media_type, @recently_watched, 5)
  #current_user information
  @current_user_likes = {}
  current_user_likes(@current_user_likes)
  
  @user_likes = {}
  user_likes(@user_likes, @user)

end

class UserController < ApplicationController

  def show
    session[:return_to] ||= request.referer
    @user = User.find(params[:id])

    @current_user_likes = {}
    current_user_likes(@current_user_likes)

    @recent_activity = {}
    recent_activity(@recent_activity)
  end

  def movies
    session[:return_to] ||= request.referer
    do_even_more_stuff("movie")
  end

  def shows
    session[:return_to] ||= request.referer
    do_even_more_stuff("series")
  end

end
