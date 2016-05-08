class MovieController < ApplicationController
	before_action :find_movie, only: [:show, :edit, :update, :destroy]

	def index
		@movies = Movie.all
	end

	def show
		
	end

	def create

	end

	private

	def find_movie
		@movie = Movie.find(session[:movie_id])
	end

	def movie_params
		params.require(:movie).permit(:title, :year, :rated, :released, :runtime, :genre, :director, :writer, :actors, :plot, :poster, :media_type, :imdb_id, :points)
	end
end
