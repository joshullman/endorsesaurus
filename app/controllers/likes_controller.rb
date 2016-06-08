class LikesController < ApplicationController
	before_action :find_likes, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def create
  	user = User.find(params[:user])
  	medium = Medium.find(params[:like])
    value = Integer(params[:value])
    is_recommendation = params["is_recommendation"]
    params[:is_recommendation] == "true" ? is_recommendation = true : is_recommendation = false
    is_current_user = true
    is_current_user = false if current_user.id != user.id
    medium_points = medium.find_associated_media.points

    like = Like.where(user_id: current_user.id, medium_id: medium.id).first
    if like && like.value == value
    elsif like && medium.media_type == "Show"
      show = medium.find_associated_media
      show.update_likes(current_user, value)
    elsif like
      old_value = like.value
      like.value = value
      like.save
      medium.increment_likes(value)
      medium.decrement_likes(old_value)
    elsif !like && medium.media_type == "Show"
      show = medium.find_associated_media
      show.watch_all(current_user, value)
      show.seasons.each do |season|
        season.distribute_points_for_recommendations(current_user, value)
      end
    elsif !like && is_current_user && is_recommendation
      if medium.media_type == "Movie"
        movie = medium.find_associated_media
        movie.distribute_points_for_recommendations(current_user, value)
      elsif medium.media_type == "Season"
        season = medium.find_associated_media
        season.watch_all(user, value, true)
      end
    elsif !like
      if medium.media_type = "Movie" || medium.media_type == "Episode"
        Like.create(user_id: current_user.id, medium_id: medium.id, media_type: medium.media_type, value: value)
        medium.increment_watches
        medium.increment_likes(value)
      elsif medium.media_type = "Season"
        medium.find_associated_media.watch_all(user, value)
      end
    end
    create_notification(current_user, medium, value)
	  redirect_to :back

  end

  def destroy
  	# delete all points that may have been distributed to the current user or other users
		recommendations = Recommendation.where(receiver_id: current_user.id, media_id: @like.media_id)
	  if recommendations
	  	if @like.value == 1
	  		recommendations.each do |rec|
	  			user = User.find(rec.sender)
	  			user.points = user.points + Media.find(@like.media_id).first.points
	  			user.save
	  		end
	  	elsif @like.value == -1
	  		recommendations.each do |rec|
	  			user = User.find(rec.sender)
	  			user.points = user.points - Media.find(@like.media_id).first.points
	  			user.points = 1 if user.points < 0
	  			user.save
	  		end
	  	end
	  end
    @like.destroy

    redirect_to :back
  end

  private

  def create_notification(user, medium, value)
    case value
      when 1
        Notification.create(user_one_id: user.id, medium_id: medium.id, media_type: medium.media_type, notification_type: "like")
      when 0
        Notification.create(user_one_id: user.id, medium_id: medium.id, media_type: medium.media_type, notification_type: "seen")
      when -1
        Notification.create(user_one_id: user.id, medium_id: medium.id, media_type: medium.media_type, notification_type: "dislike")
    end
  end

	def find_likes
		@likes = Like.find(session[:like_id])
	end

	def like_params
		params.require(:like).permit(:user_id, :media_id, :value)
	end

end
