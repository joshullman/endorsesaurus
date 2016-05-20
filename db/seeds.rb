# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: "CaptainPlanet@aol.com", password: "password", name: "CaptainPlanet" )
User.create(email: "Kuzy@aol.com", password: "password", name: "Kuzy")
User.create(email: "BuffaloKing@aol.com", password: "password", name: "BuffaloKing")
User.create(email: "TheWizard@aol.com", password: "password", name: "TheWizard")
User.create(email: "Banana@aol.com", password: "password", name: "Banana")
User.create(email: "BlackWidow@aol.com", password: "password", name: "BlackWidow" )
User.create(email: "TheSaxMan@aol.com", password: "password", name: "TheSaxMan" )
User.create(email: "Carissi@aol.com", password: "password", name: "Carissi" )
User.create(email: "Chompy@aol.com", password: "password", name: "Chompy" )
User.create(email: "WolfMan@aol.com", password: "password", name: "WolfMan")
User.create(email: "MasterMike@aol.com", password: "password", name: "MasterMike")
User.create(email: "WhitePearl@aol.com", password: "password", name: "WhitePearl")
User.create(email: "Kassanova@aol.com", password: "password", name: "Kassanova")
User.create(email: "Scoobs@aol.com", password: "password", name: "Scoobs")
User.create(email: "Chefe@aol.com", password: "password", name: "Chefe")
User.create(email: "TheAdmiral@aol.com", password: "password", name: "TheAdmiral")
User.create(email: "Jenga@aol.com", password: "password", name: "Jenga")
User.create(email: "Banner@aol.com", password: "password", name: "Banner")
User.create(email: "BigKahuna@aol.com", password: "password", name: "BigKahuna")
User.create(email: "BennyAndTheJets@aol.com", password: "password", name: "BennyAndTheJets")
User.create(email: "TheDragon@aol.com", password: "password", name: "TheDragon")
User.create(email: "EZE@aol.com", password: "password", name: "EZE")
User.create(email: "ActionHank@aol.com", password: "password", name: "ActionHank")
User.create(email: "TheMatador@aol.com", password: "password", name: "TheMatador")
User.create(email: "SubZero@aol.com", password: "password", name: "SubZero")
User.create(email: "WildCard@aol.com", password: "password", name: "WildCard")
User.create(email: "Tasty@aol.com", password: "password", name: "Tasty")
User.create(email: "KarateKid@aol.com", password: "password", name: "KarateKid")
User.create(email: "Boomer@aol.com", password: "password", name: "Boomer")
User.create(email: "TomTom@aol.com", password: "password", name: "TomTom")
User.create(email: "BrickThorn@aol.com", password: "password", name: "BrickThorn")
User.create(email: "ChampMan@aol.com", password: "password", name: "ChampMan")
User.create(email: "FrogPrince@aol.com", password: "password", name: "FrogPrince")


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

	tags = api["Genre"].split(", ")
	p tags
	tags.each do |tag|
		if Tag.where(name: tag).empty?
			Tag.create(name: tag)
		end
	end

	if api["Type"] == "series"
		series = {"Response" => "True"}
		season_num = 1
		med = Medium.create(media_type: "Show")
		show = Show.create(
			title: api["Title"],
			year: api["Year"],
			rated: api["Rated"],
			released: api["Released"],
			creator: api["Writer"],
			actors: api["Actors"],
			plot: api["Plot"],
			poster: api["Poster"],
			imdb_id: imdb_url,
			medium_id: med.id
		)
		med.update(related_id: show.id)
		tags.each do |tag|
			t = Tag.where(name: tag).first
			MediaTag.create(medium_id: med.id, tag_id: t.id)
		end
		while series["Response"] == "True"
			episodes = {"Response" => "True"}
			episode_num = 1
			url = URI.parse("http://www.omdbapi.com/\?t\=#{api["Title"].gsub(" ", "%20")}\&Season\=#{season_num}")
			req = Net::HTTP::Get.new(url.to_s)
			res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
			series = JSON.parse(res.body)
			break if series["Response"] != "True"
			med = Medium.create(media_type: "Season")
			season = Season.create(
				title: api["Title"],
				show_id: show.id,
				season_num: season_num,
				medium_id: med.id
			)
			med.update(related_id: season.id)

				while episodes["Response"] == "True"
					url = URI.parse("http://www.omdbapi.com/\?t\=#{api["Title"].gsub(" ", "%20")}\&Season\=#{season_num}\&Episode\=#{episode_num}")
					req = Net::HTTP::Get.new(url.to_s)
					res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
					episodes = JSON.parse(res.body)
					break if episodes["Response"] != "True"
					runtime = api["Runtime"].gsub(" min", "").to_i
					med = Medium.create(media_type: "Episode")
					episode = Episode.create(
						season_id: season.id,
						imdb_id: api["imdbID"],
						medium_id: med.id,
						episode_num: api["Episode"].to_i,
						episode_title: api["Title"],
						runtime: runtime,
						released: api["Released"],
						writer: api["Writer"],
						director: api["Director"],
						plot: api["Plot"],
						actors: api["Actors"],
						poster: api["Poster"]
					)
					med.update(related_id: episode.id)
					p [season_num, episode_num]
					episode_num += 1
				end

			season_num += 1
		end
	else
		runtime = api["Runtime"].gsub(" min", "").to_i
		med = Medium.create(media_type: "Movie")
		mov = Movie.create(
			title: api["Title"],
			year: api["Year"],
			rated: api["Rated"],
			released: api["Released"],
			runtime: api["Runtime"],
			director: api["Director"],
			writer: api["Writer"],
			actors: api["Actors"],
			plot: api["Plot"],
			poster: api["Poster"],
			media_type: api["Type"],
			imdb_id: imdb_url,
			medium_id: med.id
		)
		med.update(related_id: mov.id)
		tags.each do |tag|
			t = Tag.where(name: tag).first
			MediaTag.create(medium_id: med.id, tag_id: t.id)
		end
	end

end

256.times do
	user = 1
	media = 1
	value = 0
	until Like.where(user_id: user, medium_id: media).first == nil && Medium.find(media).media_type != "Show"
		user = rand(32) + 1
		media = rand(48) + 1
		value = rand(3) - 1
	end
	Like.create(user_id: user, medium_id: media, value: value)
	med = Medium.find(media)
	med.increment_watches
	med.increment_likes(value)
	case value
		when 1
			Notification.create(user_one_id: user, medium_id: media, notification_type: "like")
		when 0
			Notification.create(user_one_id: user, medium_id: media, notification_type: "seen")
		when -1
			Notification.create(user_one_id: user, medium_id: media, notification_type: "dislike")
	end
end

256.times do 
	sender = 0
	receiver = 0
	media = 0
	until sender != receiver && Recommendation.where(sender_id: sender, receiver_id: receiver, medium_id: media).first == nil && Medium.find(media).media_type != "Show"
		sender = rand(32) + 1
		receiver = rand(32) + 1
		media = rand(48) + 1
	end
	if Like.where(user_id: receiver, medium_id: media).first == nil
		Recommendation.create(sender_id: sender, receiver_id: receiver, medium_id: media)
		med = Medium.find(media)
		med.increment_recommends
    Notification.create(user_one_id: sender, user_two_id: receiver, medium_id: media, notification_type: "recommendation")
	end
end


192.times do
	user = 0
	friend = 0
	accepted = 0
	
	until user != friend && Friendship.where(user_id: user, friend_id: friend).first == nil && Friendship.where(user_id: friend, friend_id: user).first == nil
		user = rand(32) + 1
		friend = rand(32) + 1
		accepted = rand(2) + 1
	end

	accepted == 1 ? accepted = true : accepted = false
  Notification.create(user_one_id: user, user_two_id: friend, notification_type: "friends")
	Friendship.create(user_id: user, friend_id: friend, accepted: accepted)
end