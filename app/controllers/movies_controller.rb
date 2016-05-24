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

  	@current_user_likes = current_user.user_likes
	end

	def show
		med = Movie.find(params[:id]).medium.id
  	@current_user_likes = current_user.user_likes
  	@friends_like = friends_like(med, 1)
  	@friends_seen = friends_like(med, 0)
  	@friends_dislike = friends_like(med, -1)

	end

	def create

	end

	def search

	end

	private

	def friends_like(id, value)
		friends = []
		current_user.friends.each do |friend|
			friends << friend if friend.user_likes[id] == value
		end
		friends
	end

	def find_movie
		@movie = Movie.find(params[:id])
	end

	def movie_params
		params.require(:movie).permit(:title, :year, :rated, :released, :runtime, :genre, :director, :writer, :actors, :plot, :poster, :media_type, :imdb_id, :points)
	end

end
