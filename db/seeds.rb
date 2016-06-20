def create_notification(user, medium, value)
  case value
    when 1
      Notification.create(user_one_id: user.id, medium_id: medium.id, media_type: medium.media_type, notification_type: "like")
    when 0
      Notification.create(user_one_id: user.id, medium_id: medium.id, media_type: medium.media_type, notification_type: "seen")
    when -1
      Notification.create(user_one_id: user.id, medium_id: medium.id, media_type: medium.media_type, notification_type: "dislike")
  end
end

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

current_user = User.first

media = [
	"tt0944947",
	"tt0110912",
	"tt0076759",
	"tt0780536",
	"tt2861424",
	"tt0082971",
	"tt1475582",
	"tt0407887",
	"tt1375666",
	"tt0120737",
	"tt0133093",
	"tt0177789",
	"tt0303461",
	"tt0213338",
	"tt0117705",
	"tt1185834",
	"tt0783233",
	"tt0314331",
	"tt0364725",
	"tt0838283",
	"tt0196229",
	"tt0116483",
	"tt0068646",
	"tt0108052",
	"tt0137523",
	"tt0047478",
	"tt0114369",
	"tt0102926",
	"tt0110413",
	"tt0064116",
	"tt0120815",
	"tt0816692",
	"tt0120689",
	"tt0103064",
	"tt0253474",
	"tt0088763",
	"tt2582802",
	"tt0209144",
	"tt0172495",
	"tt0078788",
	"tt0482571",
	"tt0078748",
	"tt1853728",
	"tt0081505",
	"tt0910970",
	"tt0169547",
	"tt0090605",
	"tt0119698",
	"tt0364569",
	"tt0052357",
	"tt0105236",
	"tt0211915",
	"tt0112573",
	"tt0066921",
	"tt0338013",
	"tt0086879",
	"tt0070735",
	"tt0062622",
	"tt0208092",
	"tt0071853",
	"tt0361748",
	"tt0114709",
	"tt0059578",
	"tt0086250",
	"tt0055630",
	"tt0053291",
	"tt0119217",
	"tt1049413",
	"tt0105695",
	"tt0095016",
	"tt0113277",
	"tt0096283",
	"tt0050212",
	"tt0083658",
	"tt0120735",
	"tt0993846",
	"tt0268978",
	"tt0434409",
	"tt1205489",
	"tt0118715",
	"tt0077416",
	"tt0117951",
	"tt0116282",
	"tt0031381",
	"tt0061512",
	"tt0892769",
	"tt0167404",
	"tt0266543",
	"tt0084787",
	"tt0477348",
	"tt0266697",
	"tt0469494",
	"tt1392190",
	"tt0064115",
	"tt0092005",
	"tt1431045",
	"tt0093779",
	"tt0052311",
	"tt0075686"
]

# Create Media
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
		seasons_points = 0
		total_episodes_count = 0

		show_med = Medium.create(media_type: "Show")
		show = show_med.create_show(
			title: api["Title"],
			year: api["Year"],
			rated: api["Rated"],
			released: api["Released"],
			runtime: api["Runtime"],
			creator: api["Writer"],
			actors: api["Actors"],
			plot: api["Plot"],
			poster: api["Poster"],
			imdb_id: imdb_url,
		)

		tags.each do |tag|
			t = Tag.where(name: tag).first
			MediaTag.create(medium_id: show_med.id, tag_id: t.id)
		end
		while series["Response"] == "True"
			episodes = {"Response" => "True"}
			episode_num = 1
			episodes_points = 0

			url = URI.parse("http://www.omdbapi.com/\?t\=#{api["Title"].gsub(" ", "%20")}\&Season\=#{season_num}")
			req = Net::HTTP::Get.new(url.to_s)
			res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
			series = JSON.parse(res.body)

			break if series["Response"] != "True"
			season_med = Medium.create(media_type: "Season")
			season = season_med.create_season(
				title: api["Title"],
				imdb_id: api["imdbID"],
				show_id: show.id,
				season_num: season_num,
			)

				while episodes["Response"] == "True"
					url = URI.parse("http://www.omdbapi.com/\?t\=#{api["Title"].gsub(" ", "%20")}\&Season\=#{season_num}\&Episode\=#{episode_num}")
					req = Net::HTTP::Get.new(url.to_s)
					res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
					episodes = JSON.parse(res.body)
					break if episodes["Response"] != "True"
					runtime = api["Runtime"].gsub(" min", "").to_i
					points = (runtime.to_f/30).ceil
					episodes_points += points
					episode_med = Medium.create(media_type: "Episode")
					episode = episode_med.create_episode(
						season_id: season.id,
						imdb_id: api["imdbID"],
						episode_num: episode_num,
						season_num: season_num,
						title: api["Title"],
						runtime: api["Runtime"],
						released: api["Released"],
						writer: api["Writer"],
						director: api["Director"],
						plot: api["Plot"],
						actors: api["Actors"],
						poster: api["Poster"],
						points: points,
						show_id: season.show.id
					)
					p [season_num, episode_num]
					episode_num += 1
				end
			season.update(episode_count: episode_num-1)
			season.update(points: episodes_points)
			seasons_points += episodes_points
			season_num += 1
			total_episodes_count += episode_num-1
		end
		show.update(points: seasons_points)
		show.update(season_count: season_num-1)
		show.update(episode_count: total_episodes_count)
	else
		runtime = api["Runtime"].gsub(" min", "").to_i
		points = (runtime.to_f/30).ceil
		movie_med = Medium.create(media_type: "Movie")
		mov = movie_med.create_movie(
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
			imdb_id: imdb_url,
			points: points
		)
		tags.each do |tag|
			t = Tag.where(name: tag).first
			MediaTag.create(medium_id: movie_med.id, tag_id: t.id)
		end
	end

end

# Creating Likes
p "Creating Likes"
384.times do
	user = rand(User.count) + 1
	media = rand(Medium.count) + 1
	value = rand(3) - 1
	until Like.where(user_id: user, medium_id: media).first == nil
		user = rand(User.count) + 1
		media = rand(Medium.count) + 1
		value = rand(3) - 1
	end
	med = Medium.find(media)
	med.find_associated_media.watch(User.find(user), value)
	create_notification(User.find(user), med, value)
end

# Creating Recommendations
p "Creating Recommendations"
i = 1
384.times do 
	sender = 0
	receiver = 0
	media = 0

	until sender != receiver && !Medium.find(media).find_associated_media.recommended_to?(receiver, sender)
		sender = rand(User.count) + 1
		receiver = rand(User.count) + 1
		media = rand(Medium.count) + 1
	end

	medium = Medium.find(media)
	medium.find_associated_media.recommend_to([receiver], sender)
	Notification.create(user_one_id: sender, user_two_id: receiver, medium_id: medium.id, media_type: medium.media_type, notification_type: "recommendation")
	p "completed #{i} out of 384 recommendations"
	i += 1
end

# Liking Recommendations
p "Liking Recommendations"
128.times do
	user_one = rand(User.count) + 1
	until User.find(user_one).received_recs.sample != nil
		user_one = rand(User.count) + 1
	end
	value = rand(3) - 1
	medium = User.find(user_one).received_recs.sample.medium

	medium.find_associated_media.watch(User.find(user_one), value)
	create_notification(User.find(user_one), medium, value)

end

# Adding Friends
p "Adding Friends"
192.times do
	user = 0
	friend = 0
	accepted = 0
	
	until user != friend && Friendship.where(user_id: user, friend_id: friend).first == nil && Friendship.where(user_id: friend, friend_id: user).first == nil
		user = rand(User.count) + 1
		friend = rand(User.count) + 1
		accepted = rand(2) + 1
	end

	accepted == 1 ? accepted = true : accepted = false
  Notification.create(user_one_id: user, user_two_id: friend, notification_type: "friends")
	Friendship.create(user_id: user, friend_id: friend, accepted: accepted)
end

