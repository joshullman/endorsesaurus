class MediaController < ApplicationController
	before_action :find_medium, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

	def index
    session[:return_to] ||= request.referer
    @most_watched_movies = Medium.where(media_type: "Movie").order(watched_count: :desc).limit(10).map {|movie| movie = movie.find_associated_media}
    @most_liked_movies = Medium.where(media_type: "Movie").order(liked_count: :desc).limit(10).map {|movie| movie = movie.find_associated_media}
    @most_recommended_movies = Medium.where(media_type: "Movie").order(recommended_count: :desc).limit(10).map {|movie| movie = movie.find_associated_media}

    @most_watched_seasons = Medium.where(media_type: "Season").order(watched_count: :desc).limit(10).map {|show| show = show.find_associated_media}
    @most_liked_seasons = Medium.where(media_type: "Season").order(liked_count: :desc).limit(10).map {|show| show = show.find_associated_media}
    @most_recommended_seasons = Medium.where(media_type: "Season").order(recommended_count: :desc).limit(10).map {|show| show = show.find_associated_media}

  	@current_user_likes = current_user.current_user_likes
	end

  # def create
  # 	title = params[:title]
  # 	title.gsub(" ", "%20")

  # 	url = URI.parse("http://www.omdbapi.com/\?t\=#{title}")
  # 	req = Net::HTTP::Get.new(url.to_s)
  # 	res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
  # 	api = JSON.parse(res.body)
  # 	media_points = 0

  # 	if api["Type"] == "series"
  # 		series = {"Response" => "True"}
  # 		season = 1
  # 		while series["Response"] == "True"
  # 			url = URI.parse("http://www.omdbapi.com/\?t\=#{api["Title"].gsub(" ", "%20")}\&Season\=#{season}")
  # 			req = Net::HTTP::Get.new(url.to_s)
  # 			res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
  # 			series = JSON.parse(res.body)
  # 			break if series["Response"] != "True"
  # 			runtime = api["Runtime"].gsub(" min", "").to_i
  # 			media_points = series["Episodes"].length * (runtime.to_f/30).ceil
  # 			@medium = Medium.new(
  # 				title: api["Title"],
  # 				year: api["Year"],
  # 				rated: api["Rated"],
  # 				released: api["Released"],
  # 				runtime: api["Runtime"],
  # 				genre: api["Genre"],
  # 				director: api["Director"],
  # 				writer: api["Writer"],
  # 				actors: api["Actors"],
  # 				plot: api["Plot"],
  # 				awards: api["Awards"],
  # 				poster: api["Poster"],
  # 				media_type: api["Type"],
  # 				imdb_id: imdb_url,
  # 				season: season,
  # 				points: media_points
  # 				)
  # 			season += 1
  # 		end
  # 	else
  # 		runtime = api["Runtime"].gsub(" min", "").to_i
  # 		media_points = (runtime.to_f/30).ceil
  # 		@medium = Medium.new(
  # 			title: api["Title"],
  # 			year: api["Year"],
  # 			rated: api["Rated"],
  # 			released: api["Released"],
  # 			runtime: api["Runtime"],
  # 			genre: api["Genre"],
  # 			director: api["Director"],
  # 			writer: api["Writer"],
  # 			actors: api["Actors"],
  # 			plot: api["Plot"],
  # 			awards: api["Awards"],
  # 			poster: api["Poster"],
  # 			media_type: api["Type"],
  # 			imdb_id: imdb_url,
  # 			points: media_points
  # 		)
  # 	end

  #   if @medium.save
  #     redirect_to @medium, notice: 'Medium was successfully created.'
  #   else
  #     render action: "new"
  #   end
  # end

	private

	def find_medium
		p params[:id]
		@medium = Medium.find(params[:id])
	end

	def medium_params
		params.require(:medium).permit(:type, :related_id)
	end

end
