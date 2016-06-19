class ShowsController < ApplicationController
	before_action :find_show, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

	def index
		@all_tags = Tag.all

		@percents = {}

		@tags = {}
		@all_tags.each do |tag|
			shows = tag.shows
			@tags[tag] = shows
			shows.each {|show| @percents[show.medium_id] = show.percents}
		end

		@most_watched_shows = Medium.where(media_type: "Show").order(watched_count: :desc).limit(10).map {|show| show = show.find_associated_media}
    @most_liked_shows = Medium.where(media_type: "Show").order(liked_count: :desc).limit(10).map {|show| show = show.find_associated_media}
    @most_recommended_shows = Medium.where(media_type: "Show").order(recommended_count: :desc).limit(10).map {|show| show = show.find_associated_media}

    @most_watched_shows.each {|show| @percents[show.medium_id] = show.percents }
  	@most_liked_shows.each {|show| @percents[show.medium_id] = show.percents }
  	@most_recommended_shows.each {|show| @percents[show.medium_id] = show.percents }

		@current_user_likes = current_user.user_show_likes
	end

	def show

		@seasons = @show.seasons
		@percents = @show.percents
		@season_likes = {}
		@season_percent = []
		@seasons.each do |season|
			med = Season.find(season.id).medium.id
			@season_likes[[med, 1]] = friends_like(med, 1)
			@season_likes[[med, 0]] = friends_like(med, 0)
			@season_likes[[med, -1]] = friends_like(med, -1)
			@season_percent << season.percents
		end

  	@current_user_likes = current_user.user_likes

  	@current_user_progress = current_user.show_progress(@show)
	end

	def create
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
