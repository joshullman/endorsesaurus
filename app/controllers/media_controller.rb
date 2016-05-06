class MediaController < ApplicationController
	before_action :find_media, only: [:show, :edit, :update, :destroy]

	def index
		@movies = Medium.all.where(media_type: "movie")
		@shows = Show.all

		current_user_likes = Like.where(user_id: current_user.id)
  	@current_user_likes = {}
  	current_user_likes.each do |like|
  		@current_user_likes[Medium.find(like.medium_id)] = like.value
  	end
	end

  def new
    @medium = Medium.new
  end

  def show
  	current_user_likes = Like.where(user_id: current_user.id)
  	@current_user_likes = {}
  	current_user_likes.each do |like|
  		@current_user_likes[Medium.find(like.medium_id)] = like.value
  	end
  end

  def create
  	title = params[:title]
  	title.gsub(" ", "%20")

  	url = URI.parse("http://www.omdbapi.com/\?t\=#{title}")
  	req = Net::HTTP::Get.new(url.to_s)
  	res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
  	api = JSON.parse(res.body)
  	media_points = 0

  	if api["Type"] == "series"
  		series = {"Response" => "True"}
  		season = 1
  		while series["Response"] == "True"
  			url = URI.parse("http://www.omdbapi.com/\?t\=#{api["Title"].gsub(" ", "%20")}\&Season\=#{season}")
  			req = Net::HTTP::Get.new(url.to_s)
  			res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
  			series = JSON.parse(res.body)
  			break if series["Response"] != "True"
  			runtime = api["Runtime"].gsub(" min", "").to_i
  			media_points = series["Episodes"].length * (runtime.to_f/30).ceil
  			@medium = Medium.new(
  				title: api["Title"],
  				year: api["Year"],
  				rated: api["Rated"],
  				released: api["Released"],
  				runtime: api["Runtime"],
  				genre: api["Genre"],
  				director: api["Director"],
  				writer: api["Writer"],
  				actors: api["Actors"],
  				plot: api["Plot"],
  				awards: api["Awards"],
  				poster: api["Poster"],
  				media_type: api["Type"],
  				imdb_id: imdb_url,
  				season: season,
  				points: media_points
  				)
  			season += 1
  		end
  	else
  		runtime = api["Runtime"].gsub(" min", "").to_i
  		media_points = (runtime.to_f/30).ceil
  		@medium = Medium.new(
  			title: api["Title"],
  			year: api["Year"],
  			rated: api["Rated"],
  			released: api["Released"],
  			runtime: api["Runtime"],
  			genre: api["Genre"],
  			director: api["Director"],
  			writer: api["Writer"],
  			actors: api["Actors"],
  			plot: api["Plot"],
  			awards: api["Awards"],
  			poster: api["Poster"],
  			media_type: api["Type"],
  			imdb_id: imdb_url,
  			points: media_points
  		)
  	end

    if @medium.save
      redirect_to @medium, notice: 'Medium was successfully created.'
    else
      render action: "new"
    end
  end

  def destroy
    @medium.destroy

    redirect_to media_url
  end

	private

	def find_media
		p params[:id]
		@medium = Medium.find(params[:id])
	end

	def medium_params
		params.require(:medium).permit(:title, :year, :rated, :released, :runtime, :genre, :director, :writer, :actors, :plot, :awards, :poster, :media_type, :imdb_id, :season, :points)
	end
end
