# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(username: "CaptainPlanet@aol.com", password: "password")
User.create(username: "Kuzy@aol.com", password: "password")
User.create(username: "BuffaloKing@aol.com", password: "password")
User.create(username: "TheWizard@aol.com", password: "password")
User.create(username: "Banana@aol.com", password: "password")
User.create(username: "BlackWidow@aol.com", password: "password")
User.create(username: "TheSaxMan@aol.com", password: "password")
User.create(username: "Carissi@aol.com", password: "password")
User.create(username: "Chompy@aol.com", password: "password")
User.create(username: "WolfMan@aol.com", password: "password")
User.create(username: "MasterMike@aol.com", password: "password")
User.create(username: "WhitePearl@aol.com", password: "password")
User.create(username: "Kassanova@aol.com", password: "password")
User.create(username: "Scoobs@aol.com", password: "password")
User.create(username: "Chefe@aol.com", password: "password")
User.create(username: "TheAdmiral@aol.com", password: "password")
User.create(username: "Jenga@aol.com", password: "password")
User.create(username: "Banner@aol.com", password: "password")
User.create(username: "BigKahuna@aol.com", password: "password")
User.create(username: "BennyAndTheJets@aol.com", password: "password")
User.create(username: "TheDragon@aol.com", password: "password")
User.create(username: "EZE@aol.com", password: "password")
User.create(username: "ActionHank@aol.com", password: "password")
User.create(username: "TheMatador@aol.com", password: "password")
User.create(username: "SubZero@aol.com", password: "password")
User.create(username: "WildCard@aol.com", password: "password")
User.create(username: "Tasty@aol.com", password: "password")
User.create(username: "KarateKid@aol.com", password: "password")
User.create(username: "Boomer@aol.com", password: "password")
User.create(username: "TomTom@aol.com", password: "password")
User.create(username: "BrickThorn@aol.com", password: "password")
User.create(username: "ChampMan@aol.com", password: "password")
User.create(username: "FrogPrince@aol.com", password: "password")


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
	"tt1475582",
	"tt0407887",
	"tt1375666",
	"tt0120737",
	"tt0133093",
	"tt0177789",
	"tt0303461",
	"tt0112159",
	"tt0117705",
	"tt1185834",
	"tt0783233",
	"tt0314331",
	"tt0364725",
	"tt0838283",
	"tt0196229",
	"tt0116483"
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
			runtime = api["Runtime"].gsub(" min", "").to_i
			media_points = series["Episodes"].length * (runtime.to_f/30).ceil
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
			media_type: api["Type"],
			imdb_id: imdb_url,
			points: media_points
		)
	end

end

128.times do
	user = 1
	media = 1
	value = 0
	until Like.where(user_id: user, media_id: media).first == nil
		user = rand(32) + 1
		media = rand(100) + 1
		value = rand(3) - 1
	end
	p user
	p media
	p value
	Like.create(user_id: user, media_id: media, value: value)
	u = User.find(user)
	u.points = u.points + Medium.find(media).points
	u.save
end

128.times do 
	sender = 0
	receiver = 0
	media = 0
	until sender != receiver && Recommendation.where(sender: sender, receiver: receiver, media_id: media).first == nil
		sender = rand(32) + 1
		receiver = rand(32) + 1
		media = rand(100) + 1
	end
	if Like.where(user_id: receiver, media_id: media).first == nil
		Recommendation.create(sender: sender, receiver: receiver, media_id: media)
	end
end

