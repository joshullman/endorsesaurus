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

def season_watch_all(season, user, value)
	current_user = User.find(user)
	Like.create(user_id: current_user.id, medium_id: season.medium.id, media_type: "Season", value: value)
	season.episodes.each do |episode|
		episode.medium.increment_watches
		season.medium.increment_watches
		season.show.medium.increment_watches
		episode.medium.increment_likes(value)
		season.medium.increment_likes(value)
		season.show.medium.increment_likes(value)
		Like.create(user_id: current_user.id, medium_id: episode.medium.id, media_type: "Episode", value: value)
	end
	case value
		when 1
			Notification.create(user_one_id: current_user.id, medium_id: season.medium.id, media_type: "Season", notification_type: "like")
		when 0
			Notification.create(user_one_id: current_user.id, medium_id: season.medium.id, media_type: "Season", notification_type: "seen")
		when -1
			Notification.create(user_one_id: current_user.id, medium_id: season.medium.id, media_type: "Season", notification_type: "dislike")
	end
end

def show_watch_all(show, user, value)
	current_user = User.find(user)
	Like.create(user_id: current_user.id, medium_id: show.medium.id, media_type: "Show", value: value)
	show.seasons.each do |season|
		season_watch_all(season, current_user.id, value)
	end
	case value
		when 1
			Notification.create(user_one_id: current_user.id, medium_id: show.medium.id, media_type: "Show", notification_type: "like")
		when 0
			Notification.create(user_one_id: current_user.id, medium_id: show.medium.id, media_type: "Show", notification_type: "seen")
		when -1
			Notification.create(user_one_id: current_user.id, medium_id: show.medium.id, media_type: "Show", notification_type: "dislike")
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
	"tt0417373",
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
	"tt0116483"
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
						episode_num: api["Episode"].to_i,
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
			season.update(episode_count: episode_num)
			season.update(points: episodes_points)
			seasons_points += episodes_points
			season_num += 1
			total_episodes_count += episode_num
		end
		show.update(points: seasons_points)
		show.update(season_count: season_num)
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
256.times do
	user = rand(32) + 1
	media = rand(203) + 1
	value = rand(3) - 1
	until Like.where(user_id: user, medium_id: media).first == nil
		user = rand(32) + 1
		media = rand(203) + 1
		value = rand(3) - 1
	end
	med = Medium.find(media)
	if med.media_type == "Show" || med.media_type == "Season"
		med.find_associated_media.watch_all(User.find(user), value)
	elsif med.media_type == "Episode"
		Like.create(user_id: user, medium_id: media, media_type: "Episode", value: value)
		med.increment_watches
		med.increment_likes(value)
		med.find_associated_media.season.medium.increment_watches
		med.find_associated_media.season.medium.increment_likes(value)
		med.find_associated_media.season.show.medium.increment_watches
		med.find_associated_media.season.show.medium.increment_likes(value)
	else
		Like.create(user_id: user, medium_id: media, media_type: "Movie", value: value)
		med.increment_watches
		med.increment_likes(value)
	end
	create_notification(User.find(user), med, value)
end

# Creating Recommendations
256.times do 
	sender = 0
	receiver = 0
	media = 0

	until sender != receiver && 
	!Recommendation.where(sender_id: sender, receiver_id: receiver, medium_id: media).first && 
	Medium.find(media).media_type != "Episode"
		sender = rand(32) + 1
		receiver = rand(32) + 1
		media = rand(203) + 1
	end

	media = Medium.find(media)
	if media.media_type == "Show" && User.find(receiver).watched_all_seasons?(media.find_associated_media.id)[0] != true
		media.find_associated_media.seasons.each do |season|
			if User.find(receiver).watched_all_episodes?(media.find_associated_media.id)[0] != true
				Recommendation.create(sender_id: sender, receiver_id: receiver, medium_id: season.medium.id, media_type: "Season")
				season.medium.increment_recommends
				media.increment_recommends
			end
	    Notification.create(user_one_id: sender, user_two_id: receiver, medium_id: media.id, media_type: "Show", notification_type: "recommendation")
		end
	elsif media.media_type == "Movie" && !Like.where(user_id: receiver, medium_id: media.id).first
		Recommendation.create(sender_id: sender, receiver_id: receiver, medium_id: media.id, media_type: "Movie")
		media.increment_recommends
	  Notification.create(user_one_id: sender, user_two_id: receiver, medium_id: media.id, media_type: "Movie", notification_type: "recommendation")
	elsif media.media_type == "Season" && User.find(receiver).watched_all_episodes?(media.find_associated_media.id)[0] != true
		Recommendation.create(sender_id: sender, receiver_id: receiver, medium_id: media.id, media_type: "Season")
		media.find_associated_media.show.medium.increment_recommends
		media.increment_recommends
	  Notification.create(user_one_id: sender, user_two_id: receiver, medium_id: media.id, media_type: "Season", notification_type: "recommendation")
	end
end

# Liking Recommendations
64.times do
	user_one = rand(32) + 1
	until User.find(user_one).received_recs.sample != nil
		user_one = rand(32) + 1
	end
	value = rand(3) - 1
	medium = User.find(user_one).received_recs.sample.medium

	if medium.media_type == "Season"
		medium.find_associated_media.watch_all(User.find(user_one), value, true)
	else
		medium.find_associated_media.distribute_points_for_recommendations(User.find(user_one), value)
	end
	create_notification(User.find(user_one), medium, value)

end

# Adding Friends
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

