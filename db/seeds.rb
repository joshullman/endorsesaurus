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

current_user = User.all.first

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
		seasons_points = 0

		show_med = Medium.create(media_type: "Show")
		show = Show.create(
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
			medium_id: show_med.id
		)
		show_med.update(related_id: show.id)

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
			season = Season.create(
				title: api["Title"],
				show_id: show.id,
				season_num: season_num,
				medium_id: season_med.id,
			)
			season_med.update(related_id: season.id)

				while episodes["Response"] == "True"
					url = URI.parse("http://www.omdbapi.com/\?t\=#{api["Title"].gsub(" ", "%20")}\&Season\=#{season_num}\&Episode\=#{episode_num}")
					req = Net::HTTP::Get.new(url.to_s)
					res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
					episodes = JSON.parse(res.body)
					break if episodes["Response"] != "True"
					runtime = api["Runtime"].gsub(" min", "").to_i
					points = (runtime.to_f/30).ceil
					episodes_points += points
					season_med = Medium.create(media_type: "Episode")
					episode = Episode.create(
						season_id: season.id,
						imdb_id: api["imdbID"],
						medium_id: season_med.id,
						episode_num: api["Episode"].to_i,
						episode_title: api["Title"],
						runtime: api["Runtime"],
						released: api["Released"],
						writer: api["Writer"],
						director: api["Director"],
						plot: api["Plot"],
						actors: api["Actors"],
						poster: api["Poster"],
						points: points
					)
					season_med.update(related_id: episode.id)
					p [season_num, episode_num]
					episode_num += 1
				end
			season.update(points: episodes_points)
			seasons_points += episodes_points
			season_num += 1
		end
		show.update(points: seasons_points)
	else
		runtime = api["Runtime"].gsub(" min", "").to_i
		points = (runtime.to_f/30).ceil
		movie_med = Medium.create(media_type: "Movie")
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
			medium_id: movie_med.id,
			points: points
		)
		movie_med.update(related_id: mov.id)
		tags.each do |tag|
			t = Tag.where(name: tag).first
			MediaTag.create(medium_id: movie_med.id, tag_id: t.id)
		end
	end

end

256.times do
	user = 1
	media = 1
	value = 0
	until Like.where(user_id: user, medium_id: media).first == nil
		user = rand(32) + 1
		media = rand(368) + 1
		value = rand(3) - 1
	end
	med = Medium.find(media)
	if med.media_type == "Show" || med.media_type == "Season"
		med.find_associated_media.watch_all(value)
	else
		Like.create(user_id: user, medium_id: media, value: value)
		med.increment_watches
		med.increment_likes(value)
	end
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

	until sender != receiver && Recommendation.where(sender_id: sender, receiver_id: receiver, medium_id: media).first == nil && Medium.find(media).media_type != "Episode"
		sender = rand(32) + 1
		receiver = rand(32) + 1
		media = rand(368) + 1
	end

	if Like.where(user_id: receiver, medium_id: media).first == nil && Medium.find(media).media_type == "Show"
		Medium.find(media).find_associated_media.seasons.each do |season|
			if Like.where(user_id: receiver, medium_id: season.medium.id).first == nil
				Recommendation.create(sender_id: sender, receiver_id: receiver, medium_id: season.medium.id)
				season.medium.increment_recommends
				Medium.find(media).increment_recommends
			end
	    Notification.create(user_one_id: sender, user_two_id: receiver, medium_id: media, notification_type: "recommendation")
		end
	else
		if Like.where(user_id: receiver, medium_id: media).first == nil
			Recommendation.create(sender_id: sender, receiver_id: receiver, medium_id: media)
			med = Medium.find(media)
			med.increment_recommends
	    Notification.create(user_one_id: sender, user_two_id: receiver, medium_id: media, notification_type: "recommendation")
		end
	end
end

64.times do
	user_one = rand(32) + 1
	until User.find(user_one).received_recs.sample != nil
		user_one = rand(32) + 1
	end
	value = rand(3) - 1
	random_rec = User.find(user_one).received_recs.sample
	medium = Medium.find(random_rec.medium_id)
	medium_points = medium.find_associated_media.points

	Like.create(user_id: user_one, medium_id: medium.id, value: value)
  medium.increment_watches
  recommendations = Recommendation.where(receiver_id: user_one, medium_id: medium.id)
  if !recommendations.empty? && value == 1
    Notification.create(user_one_id: user_one, medium_id: medium.id, notification_type: "like")
    medium.increment_likes(value)
    recommendations.map do |rec|
      rec.sender.update_points(medium_points)
      Recommendation.find(rec.id).destroy
      Notification.create(user_one_id: rec.sender.id, user_two_id: user_one, medium_id: medium.id, notification_type: "liked rec")
    end
  elsif !recommendations.empty? && value == -1
    Notification.create(user_one_id: user_one, medium_id: medium.id, notification_type: "dislike")
    medium.increment_likes(value)
    recommendations.map do |rec|
      rec.sender.update_points(-medium_points)
      Recommendation.find(rec.id).destroy
      Notification.create(user_one_id: rec.sender.id, user_two_id: user_one, medium_id: medium.id, notification_type: "disliked rec")
    end
  elsif !recommendations.empty? && value == 0
    Notification.create(user_one_id: user_one, medium_id: medium.id, notification_type: "seen")
    medium.increment_likes(value)
    recommendations.map do |rec|
      Recommendation.find(rec.id).destroy
      Notification.create(user_one_id: rec.sender.id, user_two_id: user_one, medium_id: medium.id, notification_type: "seen rec")
    end
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