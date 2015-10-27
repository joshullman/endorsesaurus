# likes are a bit more complicated.  First you'll want to check if anyone has
# recommended it to you.  If they had, they all get points.
# Next, you need to add points to the user's profile.


class LikeController < ApplicationController
	before_action :find_likes, only: [:show, :edit, :update, :destroy]

	def new
    @like = Like.new
  end

  def create
    @like = Like.new(params[:like])
    # user gets his or her points anyway for participating and watching media
    current_user.points = current_user.points + Media.find(@like.media_id).first.points
  	# find recommendations that may have existed
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


    if @like.save
      redirect_to @like, notice: 'Like was successfully created.'
    else
      render action: "new"
    end
  end

  def show
  end

  def edit

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
