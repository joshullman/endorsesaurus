require 'uri'
require 'net/http'
require 'json'

title = "star wars: episode V"
title.gsub(" ", "%20")

url = URI.parse("http://www.omdbapi.com/\?t\=#{title}")
req = Net::HTTP::Get.new(url.to_s)
res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
api = JSON.parse(res.body)
p api
media_points = 0

# if api["Type"] == "series"
# 	series = {"Response" => "True"}
# 	season = 1
# 	while series["Response"] == "True"
# 		url = URI.parse("http://www.omdbapi.com/\?t\=#{api["Title"].gsub(" ", "%20")}\&Season\=#{season}")
# 		req = Net::HTTP::Get.new(url.to_s)
# 		res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
# 		series = JSON.parse(res.body)
# 		break if series["Response"] != "True"
# 		runtime = api["Runtime"].gsub(" min", "").to_i
# 		media_points = series["Episodes"].length * (runtime.to_f/30).ceil
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
# 			season: season,
# 			points: media_points
# 			)
# 		season += 1
# 	end
# else
# 	runtime = api["Runtime"].gsub(" min", "").to_i
# 	media_points = (runtime.to_f/30).ceil
# 	@medium = Medium.new(
# 		title: api["Title"],
# 		year: api["Year"],
# 		rated: api["Rated"],
# 		released: api["Released"],
# 		runtime: api["Runtime"],
# 		genre: api["Genre"],
# 		director: api["Director"],
# 		writer: api["Writer"],
# 		actors: api["Actors"],
# 		plot: api["Plot"],
# 		awards: api["Awards"],
# 		poster: api["Poster"],
# 		media_type: api["Type"],
# 		imdb_id: imdb_url,
# 		points: media_points
# 	)
# end