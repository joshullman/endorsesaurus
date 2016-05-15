# likes are a bit more complicated.  First you'll want to check if anyone has
# recommended it to you.  If they had, they all get points.
# Next, you need to add points to the user's profile.


class LikesController < ApplicationController
	before_action :find_likes, only: [:show, :edit, :update, :destroy]

  def create
  	user = User.find(params[:user])
  	medium = Medium.find(params[:like])
    value = Integer(params[:value])
    is_recommendation = params[:is_recommendation]
    is_current_user = true
    is_current_user = false if current_user.id != user.id

    like = Like.where(user_id: current_user.id, medium_id: medium.id)
    if !like.empty?
      old_value = like.first.value
      like.first.value = value
      like.first.save
      case value
        when 1
          medium.liked_count = medium.liked_count + 1
          if old_value == 0
            medium.seen_count = medium.seen_count - 1
          elsif old_value == -1
            medium.disliked_count = medium.disliked_count - 1
          end   
        when 0
          medium.seen_count = medium.seen_count + 1
          if old_value == 1
            medium.liked_count = medium.liked_count - 1
          elsif old_value == -1
            medium.disliked_count = medium.disliked_count - 1
          end
        when -1
          medium.disliked_count = medium.disliked_count + 1
          if old_value == 1
            medium.liked_count = medium.liked_count - 1
          elsif old_value == 0
            medium.seen_count = medium.seen_count - 1
          end
      end
      medium.save
    elsif like.empty? && is_current_user && is_recommendation
      Like.create(user_id: current_user.id, medium_id: medium.id, value: value)
      medium.watched_count = medium.watched_count + 1
      curr = User.find(current_user.id)
      curr.points = curr.points + medium.find_associated_media.points
      curr.save
      recommendations = Recommendation.where(receiver_id: current_user.id, medium_id: medium.id)
      if !recommendations.empty? && value == 1
        medium.liked_count = medium.liked_count + 1
        recommendations.map do |rec|
          sender = rec.sender
          sender.points = sender.points + medium.find_associated_media.points
          sender.save
          Recommendation.find(rec.id).destroy
        end
      elsif !recommendations.empty? && value == -1
        medium.disliked_count = medium.disliked_count + 1
        recommendations.map do |rec|
          sender = rec.sender
          sender.points = sender.points - medium.find_associated_media.points
          sender.points = 1 if sender.points <= 0
          sender.save
          Recommendation.find(rec.id).destroy
        end
      elsif !recommendations.empty? && value == 0
        medium.seen_count = medium.seen_count + 1
        recommendations.map do |rec|
        Recommendation.find(rec.id).destroy
        end
      end
    medium.save
    elsif like.empty? && !is_current_user
      Like.create(user_id: current_user.id, medium_id: medium.id, value: value)
      curr = User.find(current_user.id)
      curr.points = curr.points + medium.find_associated_media.points
      curr.save
      medium.watched_count = medium.watched_count + 1
      case value
        when 1
          medium.liked_count = medium.liked_count + 1
        when 0
          medium.seen_count = medium.seen_count + 1
        when -1
          medium.disliked_count = medium.disliked_count + 1
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
