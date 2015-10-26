# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(email: "Jon@got.com", password: "password")
User.create(email: "Cersei@got.com", password: "password")
User.create(email: "The_Hound@got.com", password: "password")
User.create(email: "Mad_King_Aerys@got.com", password: "password")
User.create(email: "Danerys@got.com", password: "password")
User.create(email: "Arya@got.com", password: "password")
User.create(email: "Sansa@got.com", password: "password")

media = [
	"tt1520211",
	"tt0944947",
	"tt0110912",
	"tt0410975",
	"tt0076759",
	"tt0780536",
	"tt2861424",
	"tt0417373",
	"tt0082971",
	"tt1475582"
]

media.each do |imdb_url|
	url = URI.parse("http://www.omdbapi.com/\?i\=#{imdb_url}")
	req = Net::HTTP::Get.new(url.to_s)
	res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
	api = JSON.parse(res.body)
	media_points = 0

	if api["Type"] == "series"
		series = {"Response" => "True"}
		season = 1
		while series["Response"] == "True"
			url = URI.parse("http://www.omdbapi.com/\?t\=#{api["Title"]}\&Season\=#{season}")
			req = Net::HTTP::Get.new(url.to_s)
			res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
			series = JSON.parse(res.body)
			break if series["Response"] != "True"
			media_points += series["Episodes"].length
			season += 1
		end
		runtime = api["Runtime"].gsub(" min", "").to_i
		media_points = media_points * (runtime.to_f/30).ceil
	else
		runtime = api["Runtime"].gsub(" min", "").to_i
		media_points = (runtime.to_f/30).ceil
	end


	Medium.create(
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
		points: media_points
	)
end


Like.create(user_id: 1, media_id: 1, value: 1)
user = User.find(1)
user.points = user.points + Medium.find(1).points

Like.create(user_id: 2, media_id: 1, value: 1)
user = User.find(2)
user.points = user.points + Medium.find(1).points

Like.create(user_id: 3, media_id: 1, value: 1)
user = User.find(3)
user.points = user.points + Medium.find(1).points

Like.create(user_id: 4, media_id: 1, value: 0)
user = User.find(4)
user.points = user.points + Medium.find(1).points

Like.create(user_id: 5, media_id: 1, value: 0)
user = User.find(5)
user.points = user.points + Medium.find(1).points

Like.create(user_id: 6, media_id: 1, value: -1)
user = User.find(6)
user.points = user.points + Medium.find(1).points

Like.create(user_id: 7, media_id: 1, value: -1)
user = User.find(7)
user.points = user.points + Medium.find(1).points

Like.create(user_id: 1, media_id: 2, value: 0)
user = User.find(1)
user.points = user.points + Medium.find(2).points

Like.create(user_id: 2, media_id: 2, value: 0)
user = User.find(2)
user.points = user.points + Medium.find(2).points

Like.create(user_id: 3, media_id: 3, value: -1)
user = User.find(3)
user.points = user.points + Medium.find(3).points

Like.create(user_id: 4, media_id: 3, value: 0)
user = User.find(4)
user.points = user.points + Medium.find(3).points

Like.create(user_id: 5, media_id: 4, value: 1)
user = User.find(5)
user.points = user.points + Medium.find(4).points

Like.create(user_id: 6, media_id: 4, value: 0)
user = User.find(6)
user.points = user.points + Medium.find(4).points

Like.create(user_id: 7, media_id: 5, value: 1)
user = User.find(7)
user.points = user.points + Medium.find(5).points

Like.create(user_id: 1, media_id: 5, value: 0)
user = User.find(1)
user.points = user.points + Medium.find(5).points

Like.create(user_id: 2, media_id: 6, value: -1)
user = User.find(2)
user.points = user.points + Medium.find(6).points

Like.create(user_id: 3, media_id: 6, value: 0)
user = User.find(3)
user.points = user.points + Medium.find(6).points

Like.create(user_id: 4, media_id: 7, value: 1)
user = User.find(4)
user.points = user.points + Medium.find(7).points

Like.create(user_id: 5, media_id: 7, value: 0)
user = User.find(5)
user.points = user.points + Medium.find(7).points

Like.create(user_id: 6, media_id: 8, value: 1)
user = User.find(6)
user.points = user.points + Medium.find(8).points

Like.create(user_id: 7, media_id: 8, value: 0)
user = User.find(7)
user.points = user.points + Medium.find(8).points

Like.create(user_id: 1, media_id: 9, value: -1)
user = User.find(1)
user.points = user.points + Medium.find(9).points

Like.create(user_id: 2, media_id: 9, value: 0)
user = User.find(2)
user.points = user.points + Medium.find(9).points

Like.create(user_id: 3, media_id: 9, value: -1)
user = User.find(3)
user.points = user.points + Medium.find(9).points

Like.create(user_id: 4, media_id: 9, value: 0)
user = User.find(4)
user.points = user.points + Medium.find(9).points

Like.create(user_id: 5, media_id: 9, value: 1)
user = User.find(5)
user.points = user.points + Medium.find(9).points

Like.create(user_id: 6, media_id: 9, value: 0)
user = User.find(6)
user.points = user.points + Medium.find(9).points

Like.create(user_id: 7, media_id: 10, value: -1)
user = User.find(7)
user.points = user.points + Medium.find(10).points

28.times do 
	sender = 0
	receiver = 0
	until sender != receiver
		sender = rand(7) + 1
		receiver = rand(7) + 1
	end
	media = rand(10) + 1
	unless Like.where(user_id: receiver, media_id: media).first
		Recommendation.create(sender: sender, receiver: receiver, media_id: media)
	end
end

