class ShowsController < ApplicationController
	before_action :find_show, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

	def index
		session[:return_to] ||= request.referer
		@all_tags = Tag.all

		@tags = {}
		@all_tags.each do |tag|
			shows = tag.shows
			@tags[tag] = shows
		end

		@current_user_likes = current_user.current_user_likes
	end

	def show
		session[:return_to] ||= request.referer
		@seasons = @show.seasons

		@current_user_likes = current_user.current_user_likes
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
