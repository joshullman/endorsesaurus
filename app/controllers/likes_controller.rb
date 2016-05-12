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
      like.first.value = value
      like.first.save
    elsif like.empty? && is_current_user && is_recommendation
      Like.create(user_id: current_user.id, medium_id: medium.id, value: value)
      curr = User.find(current_user.id)
      curr.points = curr.points + medium.find_associated_media.points
      curr.save
      recommendations = Recommendation.where(receiver_id: current_user.id, medium_id: medium.id)
      if !recommendations.empty? && value == 1
        recommendations.map do |rec|
          sender = rec.sender
          sender.points = sender.points + medium.find_associated_media.points
          sender.save
          Recommendation.find(rec.id).destroy
        end
      elsif !recommendations.empty? && value == -1
        recommendations.map do |rec|
          sender = rec.sender
          sender.points = sender.points - medium.find_associated_media.points
          sender.points = 1 if sender.points <= 0
          sender.save
          Recommendation.find(rec.id).destroy
        end
      elsif !recommendations.empty? && value == 0
        recommendations.map do |rec|
        Recommendation.find(rec.id).destroy
        end
      end
    elsif like.empty? && !is_current_user
      Like.create(user_id: current_user.id, medium_id: medium.id, value: value)
      curr = User.find(current_user.id)
      curr.points = curr.points + medium.find_associated_media.points
      curr.save
    end

    case medium.media_type
	    when "Movie"
	    	redirect_to movies_user_path(user)
	    when "Season"
	    	redirect_to shows_user_path(user)
    end
  end

  def update
  	#find users that and update their points accordingly
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

    redirect_to likes_url
  end

  private

	def find_likes
		@likes = Like.find(session[:like_id])
	end

	def like_params
		params.require(:like).permit(:user_id, :media_id, :value)
	end

end
