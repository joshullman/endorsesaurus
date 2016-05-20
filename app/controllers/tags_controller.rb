class TagsController < ApplicationController
	before_action :find_tag, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

	def index
		@tags = Tag.all.order(:name)

		@current_user_likes = current_user.user_likes
	end

	def show
		@movies = @tag.movies
		@shows = @tag.shows

  	@current_user_likes = current_user.user_likes
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
