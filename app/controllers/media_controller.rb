class MediaController < ApplicationController
  before_action :authenticate_user!

	def index
    @most_watched_movies = Medium.where(media_type: "Movie").order(watched_count: :desc).limit(10).map {|movie| movie = movie.find_associated_media}
    @most_liked_movies = Medium.where(media_type: "Movie").order(liked_count: :desc).limit(10).map {|movie| movie = movie.find_associated_media}
    @most_recommended_movies = Medium.where(media_type: "Movie").order(recommended_count: :desc).limit(10).map {|movie| movie = movie.find_associated_media}

    @most_watched_shows = Medium.where(media_type: "Show").order(watched_count: :desc).limit(10).map {|show| show = show.find_associated_media}
    @most_liked_shows = Medium.where(media_type: "Show").order(liked_count: :desc).limit(10).map {|show| show = show.find_associated_media}
    @most_recommended_shows = Medium.where(media_type: "Show").order(recommended_count: :desc).limit(10).map {|show| show = show.find_associated_media}

  	@current_user_likes = current_user.user_likes
	end

  def search
    title = params[:title]
    media_type = params[:media]
    @percents = {}
    if media_type == "Shows"
      @show_results = Show.search {fulltext "#{title}"}.results
      @show_results.each {|show| @percents[show.medium_id] = show.percents}
    elsif media_type == "Movies"
      @movie_results = Movie.search {fulltext "#{title}"}.results
      @movie_results.each {|movie| @percents[movie.medium_id] = movie.percents}
    end

    @current_user_likes = current_user.user_likes
  end

end
