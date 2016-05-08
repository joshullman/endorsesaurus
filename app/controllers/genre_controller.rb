class GenreController < ApplicationController
	before_action :find_genres, only: [:show, :edit, :update, :destroy]

	def index
		@genres = Genre.all
	end

	def show
	end

	def create

	end

	private

	def find_genres
		@genres = Genre.find(session[:genre_id])
	end

	def genre_params
		params.require(:genre).permit(:name)
	end

end
