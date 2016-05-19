# database = File.open("omdb/omdbFull.txt", 'r:ISO-8859-1', &:read)

# omdb_ids = database.scan(/\r\n\d*/)

# split = database.split(/\r\n\d*/)
# media_array = []
# split.each do |string|
# 	thingy = string.split(/\t/)
# 	media_array << thingy
# end

# j = 0
# i = -1
# media_array.each do |array|
# 	array.unshift(omdb_ids[i].gsub!(/\r\n/, "")) 	unless j == 0
# 	i += 1
# 	j += 1
# end

# p media_array[1]
# p media_array.last

# media = []
# media_array.each do |med|
# 	api = {}
# 	api["omdb_id"] = med[0]
# 	api["imdb_url"] = med[2]
# 	api["Title"] = med[3]
# 	api["Year"] = med[4]
# 	api["Rated"] = med[5]
# 	api["Released"] = med[8]
# 	api["Runtime"] = med[6]
# 	api["Genre"] = med[7]
# 	api["Director"] = med[9]
# 	api["Writer"] = med[10]
# 	api["Actors"] = med[11]
# 	api["Plot"] = med[16]
# 	api["Poster"] = med[15]
# 	api["Type"] = med[-1]
# 	media << api
# end

# p media[1]

episodes_database = File.open("omdb/omdbEpisodes.txt", 'r:ISO-8859-1', &:read)

episodes_omdb_ids = episodes_database.scan(/\r\n\d*/)

episodes_split = episodes_database.split(/\r\n\d*/)
media_array = []
episodes_split.each do |string|
	thingy = string.split(/\t/)
	episodes_array << thingy
end

j = 0
i = -1
episodes_array.each do |array|
	array.unshift(episodes_omdb_ids[i].gsub!(/\r\n/, "")) 	unless j == 0
	i += 1
	j += 1
end

p episodes_array[0]
p episodes_array[1]

episodes = []
episodes_array.each do |med|
	api = {}
	api["omdb_id"] = med[0]
	api["imdb_url"] = med[1]
	api["Title"] = med[2]
	api["Year"] = med[3]
	api["Runtime"] = med[5]
	api["Released"] = med[7]
	api["season_num"] = med[8]
	api["episode_num"] = med[9]
	api["show_id"] = med[10]
	api["Director"] = med[12]
	api["Writer"] = med[13]
	api["Poster"] = med[18]
	api["Plot"] = med[20]
	api["Type"] = "episode"
	media << api
end

p episodes[0]
p episodes[1]

# media.each do |api|
# 	media_points = 0

# 	tags = api["Genre"].split(", ")
# 	tags.each do |tag|
# 		if Tag.where(name: tag).empty?
# 			Tag.create(name: tag)
# 		end
# 	end

# 	if api["Type"] == "series"
# 		series = {"Response" => "True"}
# 		season_num = 1
# 		med = Medium.create(media_type: "Show")
# 		show = Show.create(
# 			title: api["Title"],
# 			year: api["Year"],
# 			rated: api["Rated"],
# 			released: api["Released"],
# 			runtime: api["Runtime"],
# 			genre: api["Genre"],
# 			creator: api["Writer"],
# 			actors: api["Actors"],
# 			plot: api["Plot"],
# 			poster: api["Poster"],
# 			imdb_id: api["imdb_url"],
# 			omdb_id: api["omdb_url"],
# 			medium_id: med.id
# 			)
# 		med.update(related_id: show.id)
# 		tags.each do |tag|
# 			t = Tag.where(name: tag).first
# 			MediaTag.create(medium_id: med.id, tag_id: t.id)
# 		end
# 		while series["Response"] == "True"
# 			break if series["Response"] != "True"
# 			runtime = api["Runtime"].gsub(" min", "").to_i
# 			media_points = series["Episodes"].length * (runtime.to_f/30).ceil
# 			med = Medium.create(media_type: "Season")
# 			season = Season.create(
# 				title: api["Title"],
# 				show_id: show.id,
# 				season_num: season_num,
# 				points: media_points,
# 				medium_id: med.id,
# 				omdb_url: api["omdb_url"]
# 				)
# 			med.update(related_id: season.id)

# 			season_num += 1
# 		end
# 	else
# 		runtime = api["Runtime"].gsub(" min", "").to_i
# 		media_points = (runtime.to_f/30).ceil
# 		med = Medium.create(media_type: "Movie")
# 		mov = Movie.create(
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
# 			poster: api["Poster"],
# 			imdb_id: api["imdb_url"],
# 			imdb_id: api["omdb_id"],
# 			points: media_points,
# 			medium_id: med.id
# 		)
# 		med.update(related_id: mov.id)
# 		tags.each do |tag|
# 			t = Tag.where(name: tag).first
# 			MediaTag.create(medium_id: med.id, tag_id: t.id)
# 		end
# 	end

# end