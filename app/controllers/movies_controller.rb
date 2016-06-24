class MoviesController < ApplicationController
	before_action :find_movie, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

	def index
		@all_tags = Tag.all
  	@percents = {}

		@tags = {}
		@all_tags.each do |tag|
			movies = tag.movies.take(10)
			@tags[tag] = movies
			movies.each {|movie| @percents[movie.medium_id] = movie.percents}
		end

		@most_watched_movies = Medium.where(media_type: "Movie").order(watched_count: :desc).limit(10).map {|movie| movie = movie.find_associated_media}
    @most_liked_movies = Medium.where(media_type: "Movie").order(liked_count: :desc).limit(10).map {|movie| movie = movie.find_associated_media}
    @most_recommended_movies = Medium.where(media_type: "Movie").order(recommended_count: :desc).limit(10).map {|movie| movie = movie.find_associated_media}

  	@current_user_likes = current_user.movie_likes

  	@most_watched_movies.each {|movie| @percents[movie.medium_id] = movie.percents }
  	@most_liked_movies.each {|movie| @percents[movie.medium_id] = movie.percents }
  	@most_recommended_movies.each {|movie| @percents[movie.medium_id] = movie.percents }

	end

	def show
		med = Movie.find(params[:id]).medium.id
  	@current_user_likes = current_user.movie_likes
  	@friends_like = friends_like(med, 1)
  	@friends_seen = friends_like(med, 0)
  	@friends_dislike = friends_like(med, -1)

  	@percents = @movie.percents

	end

	def create

	end

	private

	def friends_like(id, value)
		friends = []
		current_user.friends.each do |friend|
			friends << friend if friend.movie_likes[id] == value
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
