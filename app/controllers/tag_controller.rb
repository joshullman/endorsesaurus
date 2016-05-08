class TagController < ApplicationController
	before_action :find_tag, only: [:show, :edit, :update, :destroy]

	def index
		@tags = Tag.all
	end

	def show
	end

	def create

	end

	private

	def find_tag
		@tag = Tag.find(session[:tag_id])
	end

	def tag_params
		params.require(:tag).permit(:name)
	end

end
