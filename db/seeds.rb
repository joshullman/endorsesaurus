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
			url = URI.parse("http://www.omdbapi.com/\?t\=#{api["Title"].gsub(" ", "%20")}\&Season\=#{season}")
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

28.times do
	user = 0
	media = 0
	value = 0
	until Like.where(user_id: user, media: media).first == nil
		user = rand(7) + 1
		media = rand(9) + 1
		value = rand(2) - 1
	end
	Like.create(user_id: user, media: media, value: value)
	u = User.find(user)
	u.points = u.points + Medium.find(media).points
	u.save
end

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

