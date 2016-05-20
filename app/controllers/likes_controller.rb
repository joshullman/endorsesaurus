class LikesController < ApplicationController
	before_action :find_likes, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def create
  	user = User.find(params[:user])
  	medium = Medium.find(params[:like])
    value = Integer(params[:value])
    is_recommendation = params[:is_recommendation]
    is_current_user = true
    is_current_user = false if current_user.id != user.id
    medium_points = medium.find_associated_media.points

    like = Like.where(user_id: current_user.id, medium_id: medium.id)
    if !like.empty?
      old_value = like.first.value
      like.first.value = value
      like.first.save
      medium.increment_likes(value)
      medium.decrement_likes(old_value)
      case value
        when 1
          Notification.create(user_one_id: current_user.id, medium_id: medium.id, notification_type: "like")
        when 0
          Notification.create(user_one_id: current_user.id, medium_id: medium.id, notification_type: "seen")
        when -1
          Notification.create(user_one_id: current_user.id, medium_id: medium.id, notification_type: "dislike")
      end
    elsif like.empty? && is_current_user && is_recommendation
      Like.create(user_id: current_user.id, medium_id: medium.id, value: value)
      medium.increment_watches
      recommendations = Recommendation.where(receiver_id: current_user.id, medium_id: medium.id)
      if !recommendations.empty? && value == 1
        Notification.create(user_one_id: current_user.id, medium_id: medium.id, notification_type: "like")
        medium.increment_likes(value)
        recommendations.map do |rec|
          rec.sender.update_points(medium_points)
          Recommendation.find(rec.id).destroy
          Notification.create(user_one_id: rec.sender.id, user_two_id: current_user.id, medium_id: medium.id, notification_type: "liked rec")
        end
      elsif !recommendations.empty? && value == -1
        Notification.create(user_one_id: current_user.id, medium_id: medium.id, notification_type: "dislike")
        medium.increment_likes(value)
        recommendations.map do |rec|
          rec.sender.update_points(-medium_points)
          Recommendation.find(rec.id).destroy
          Notification.create(user_one_id: rec.sender.id, user_two_id: current_user.id, medium_id: medium.id, notification_type: "disliked rec")
        end
      elsif !recommendations.empty? && value == 0
        Notification.create(user_one_id: current_user.id, medium_id: medium.id, notification_type: "seen")
        medium.increment_likes(value)
        recommendations.map do |rec|
          Recommendation.find(rec.id).destroy
          Notification.create(user_one_id: rec.sender.id, user_two_id: current_user.id, medium_id: medium.id, notification_type: "seen rec")
        end
      end
    elsif like.empty? && !is_current_user
      Like.create(user_id: current_user.id, medium_id: medium.id, value: value)
      medium.increment_watches
      medium.increment_likes(value)
      case value
        when 1
          Notification.create(user_one_id: current_user.id, medium_id: medium.id, notification_type: "like")
        when 0
          Notification.create(user_one_id: current_user.id, medium_id: medium.id, notification_type: "seen")
        when -1
          Notification.create(user_one_id: current_user.id, medium_id: medium.id, notification_type: "dislike")
      end
    end

    case medium.media_type
	    when "Movie"
	    	redirect_to :back
	    when "Season"
	    	redirect_to :back
    end
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

	def find_likes
		@likes = Like.find(session[:like_id])
	end

	def like_params
		params.require(:like).permit(:user_id, :media_id, :value)
	end

end
