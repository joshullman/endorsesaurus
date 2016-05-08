class ShowsController < ApplicationController
	before_action :find_show, only: [:show, :edit, :update, :destroy]

	def index
		@shows = Show.all

		current_user_likes = Like.where(user_id: current_user.id)
  	@current_user_likes = {}
  	current_user_likes.each do |like|
  		@current_user_likes[like.medium_id] = like.value
  	end
	end

	def show
		p "******************************************************"
		p @show
		p "******************************************************"
		@seasons = @show.seasons
		p @seasons
		p "******************************************************"

		current_user_likes = Like.where(user_id: current_user.id)
  	@current_user_likes = {}
  	current_user_likes.each do |like|
  		@current_user_likes[like.medium_id] = like.value
  	end
	end

	def create
	end

	private

	def find_show
		@show = Show.find(params[:id])
	end

	def show_params
		params.require(:show).permit(:title, :year, :rated, :released, :runtime, :genre, :creator, :actors, :plot, :poster, :imdb_id)
	end
end
