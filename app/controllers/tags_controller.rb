class TagsController < ApplicationController
	before_action :find_tag, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

	def index
		@tags = Tag.all.order(:name)

		@current_user_movie_likes = current_user.movie_likes
		@current_user_show_likes = current_user.show_likes
	end

	def show
		@percents = {}
		@movies = @tag.movies
		@most_watched_movies = @movies.sort_by {|movie| movie.medium.watched_count }.reverse!
		@most_liked_movies = @movies.sort_by {|movie| movie.medium.liked_count }.reverse!
		@most_recommended_movies = @movies.sort_by {|movie| movie.medium.recommended_count }.reverse!
		@movies.each {|movie| @percents[movie.medium_id] = movie.percents}

		@shows = @tag.shows
		@most_watched_shows = @shows.sort_by {|show| show.medium.watched_count }.reverse!
    @most_liked_shows = @shows.sort_by {|show| show.medium.liked_count }.reverse!
    @most_recommended_shows = @shows.sort_by {|show| show.medium.recommended_count }.reverse!
		@shows.each {|show| @percents[show.medium_id] = show.percents}

  	@current_user_movie_likes = current_user.movie_likes
		@current_user_show_likes = current_user.show_likes
		@current_user_likes = @current_user_movie_likes.merge(@current_user_show_likes)
	end

	def create

	end

	private

	def find_tag
		@tag = Tag.find(params[:id])
	end

	def tag_params
		params.require(:tag).permit(:name)
	end

end
