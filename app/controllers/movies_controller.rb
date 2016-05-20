class MoviesController < ApplicationController
	before_action :find_movie, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

	def index
		@all_tags = Tag.all

		@tags = {}
		@all_tags.each do |tag|
			movies = tag.movies
			@tags[tag] = movies
		end

  	@current_user_likes = current_user.current_user_likes
	end

	def show
  	@current_user_likes = current_user.current_user_likes
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
