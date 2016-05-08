class MoviesController < ApplicationController
	before_action :find_movie, only: [:show, :edit, :update, :destroy]

	def index
		@movies = Movie.all

		current_user_likes = Like.where(user_id: current_user.id)
  	@current_user_likes = {}
  	current_user_likes.each do |like|
  		@current_user_likes[like.medium_id] = like.value
  	end
	end

	def show
		
		current_user_likes = Like.where(user_id: current_user.id)
  	@current_user_likes = {}
  	current_user_likes.each do |like|
  		@current_user_likes[like.medium_id] = like.value
  	end
	end

	def create

	end

	private

	def find_movie
		@movie = Movie.find(params[:id])
	end

	def movie_params
		params.require(:movie).permit(:title, :year, :rated, :released, :runtime, :genre, :director, :writer, :actors, :plot, :poster, :media_type, :imdb_id, :points)
	end
end
