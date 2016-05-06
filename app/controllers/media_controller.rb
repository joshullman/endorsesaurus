class MediaController < ApplicationController
	before_action :find_media, only: [:show, :edit, :update, :destroy]

	def index
		@media = Medium.all

		current_user_likes = Like.where(user_id: current_user.id)
  	@current_user_likes = {}
  	current_user_likes.each do |like|
  		@current_user_likes[Medium.find(like.media_id)] = like.value
  	end
	end

  def new
    @medium = Medium.new
  end

  def show
  	# Info that I want to display:
  	# How many people overall have watched this media
  	# How many people have recommended this media
  	# How many people Like this media
  	# How many people Seen this media
  	# How many people Dislike this media
  	likes = Like.where(media_id: @medium.id)
  	@users_watched = likes.count
  	@users_like = likes.where(value: 1).count
  	@users_seen = likes.where(value: 0).count
  	@users_dislike = likes.where(value: -1).count
  	@recommendation_count = Recommendation.where(media_id: @medium.id).count

  	current_user_likes = Like.where(user_id: current_user.id)
  	@current_user_likes = {}
  	current_user_likes.each do |like|
  		@current_user_likes[Medium.find(like.media_id)] = like.value
  	end
  end

  def create
    # if recommendation exists, ignore
    # else, make recommendation

    @medium = Medium.new(params[:medium])

    if @medium.save
      redirect_to @medium, notice: 'Medium was successfully created.'
    else
      render action: "new"
    end
  end

  def destroy
    @medium.destroy

    redirect_to media_url
  end

	private

	def find_media
		p params[:id]
		@medium = Medium.find(params[:id])
	end

	def medium_params
		params.require(:medium).permit(:title, :year, :rated, :released, :runtime, :genre, :director, :writer, :actors, :plot, :awards, :poster, :media_type, :imdb_id, :season, :points)
	end
end
