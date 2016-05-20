class TagsController < ApplicationController
	before_action :find_tag, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

	def index
		@tags = Tag.all.order(:name)

		@current_user_likes = {}
		current_user_likes(@current_user_likes)
	end

	def show
		@movies = @tag.movies
		@shows = @tag.shows

  	@current_user_likes = {}
		current_user_likes(@current_user_likes)
	end

	def create

	end

	private

	def current_user_likes(instance_likes)
	  current_user_likes = Like.where(user_id: current_user.id)
	  current_user_likes.each do |like|
	    instance_likes[Medium.find(like.medium_id).id] = like.value
	  end
	end

	def find_tag
		@tag = Tag.find(params[:id])
	end

	def tag_params
		params.require(:tag).permit(:name)
	end

end
