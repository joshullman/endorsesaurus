class MoviesController < ApplicationController
	before_action :find_movie, only: [:show, :edit, :update, :destroy]

	def index
		session[:return_to] ||= request.referer

		@all_tags = Tag.all

		@tags = {}
		@all_tags.each do |tag|
			movies = tag.movies
			@tags[tag] = movies
		end

  	@current_user_likes = {}
  	current_user_likes(@current_user_likes)
	end

	def show
		session[:return_to] ||= request.referer
  	@current_user_likes = {}
  	current_user_likes(@current_user_likes)
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

	def current_user_likes(instance_likes)
	  current_user_likes = Like.where(user_id: current_user.id)
	  current_user_likes.each do |like|
	    instance_likes[Medium.find(like.medium_id).id] = like.value
	  end
	end

end
