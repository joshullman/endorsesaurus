class LikesController < ApplicationController
	before_action :find_likes, only: [:show, :edit, :update, :destroy]

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
      current_user.update_points(medium_points)
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
      current_user.update_points(medium_points)
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

  def create_like_notification(user, medium, value, user_two = nil)
    media = medium.find_associated_media
    if user_two
      case value
        when 1
          message = "#{user.name} liked #{user_two.name}'s recommendation of #{media.title}! #{user_two.name} gained #{media.points} points!" if medium.media_type == "Movie"
          message = "#{user.name} liked #{user_two.name}'s recommendation of #{media.title} season #{media.season_num}! #{user_two.name} gained #{media.points} points!" if medium.media_type == "Season"
        when 0
          message = "#{user.name} saw #{user_two.name}'s recommendation of #{media.title}! #{user_two.name} gained no points." if medium.media_type == "Movie"
          message = "#{user.name} saw #{user_two.name}'s recommendation of #{media.title} season #{media.season_num}! #{user_two.name} gained no points." if medium.media_type == "Season"
        when -1
          message = "#{user.name} disliked #{user_two.name}'s recommendation of #{media.title}! #{user_two.name} lost #{media.points} points :(." if medium.media_type == "Movie"
          message = "#{user.name} disliked #{user_two.name}'s recommendation of #{media.title} season #{media.season_num}! #{user_two.name} lost #{media.points} points :(." if medium.media_type == "Season"
      end
      Notification.create(user_id: user_two.id, message: message)
    else
      case value
        when 1
          message = "#{user.name} liked #{media.title} and gained #{media.points} points!" if medium.media_type == "Movie"
          message = "#{user.name} liked #{media.title} season #{media.season_num} and gained #{media.points} points!" if medium.media_type == "Season"
        when 0
          message = "#{user.name} saw #{media.title} and gained #{media.points} points!" if medium.media_type == "Movie"
          message = "#{user.name} saw #{media.title} season #{media.season_num} and gained #{media.points} points!" if medium.media_type == "Season"
        when -1
          message = "#{user.name} disliked #{media.title} and gained #{media.points} points anyway!" if medium.media_type == "Movie"
          message = "#{user.name} disliked #{media.title} season #{media.season_num} and gained #{media.points} points anyway!" if medium.media_type == "Season"
      end
      Notification.create(user_id: user.id, message: message)
    end
  end

	def find_likes
		@likes = Like.find(session[:like_id])
	end

	def like_params
		params.require(:like).permit(:user_id, :media_id, :value)
	end

end
