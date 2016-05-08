class ShowController < ApplicationController
	before_action :find_show, only: [:show, :edit, :update, :destroy]

	def index
	end

	def show
	end

	

	private

	def find_show
		p params[:id]
		@show = Show.find(params[:id])
	end

	def show_params
		params.require(:show).permit(:title, :year, :rated, :released, :runtime, :genre, :creator, :actors, :plot, :poster, :imdb_id)
	end
end
