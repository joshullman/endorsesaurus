class ShowsController < ApplicationController
	before_action :find_show, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

	def index
		@all_tags = Tag.all

		@tags = {}
		@all_tags.each do |tag|
			shows = tag.shows
			@tags[tag] = shows
		end

		@current_user_likes = current_user.user_likes
	end

	def show
		@seasons = @show.seasons

		@season_likes = {}
		@seasons.each do |season|
			med = Season.find(season.id).medium.id
			@season_likes[[med, 1]] = friends_like(med, 1)
			@season_likes[[med, 0]] = friends_like(med, 0)
			@season_likes[[med, -1]] = friends_like(med, -1)
		end

  	@current_user_likes = current_user.user_likes
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

	def find_show
		@show = Show.find(params[:id])
	end

	def show_params
		params.require(:show).permit(:title, :year, :rated, :released, :runtime, :genre, :creator, :actors, :plot, :poster, :imdb_id)
	end

end
