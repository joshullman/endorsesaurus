def current_user_likes(instance_likes)
  current_user_likes = Like.where(user_id: current_user.id)
  current_user_likes.each do |like|
    instance_likes[Medium.find(like.medium_id).id] = like.value
  end
end

class ShowsController < ApplicationController
	before_action :find_show, only: [:show, :edit, :update, :destroy]

	def index
		session[:return_to] ||= request.referer
		@all_tags = Tag.all

		@tags = {}
		@all_tags.each do |tag|
			shows = tag.shows
			@tags[tag] = shows
		end

		@current_user_likes = {}
		current_user_likes(@current_user_likes)
	end

	def show
		session[:return_to] ||= request.referer
		@seasons = @show.seasons

		@current_user_likes = {}
		current_user_likes(@current_user_likes)
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
