# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(username: "Jon", password: "password")
User.create(username: "Cersei", password: "password")
User.create(username: "The Hound", password: "password")
User.create(username: "Mad King Aerys", password: "password")
User.create(username: "Danerys", password: "password")
User.create(username: "Arya", password: "password")
User.create(username: "Sansa", password: "password")


Medium.create(
	title:
	year:
	rated:
	released:
	runtime:
	genre:
	director:
	writer:
	actors:
	plot:
	awards:
	poster:
	points:
	)

Like.create(user_id: 1, media_id: 1, value: 1)
Like.create(user_id: 2, media_id: 1, value: 1)
Like.create(user_id: 3, media_id: 1, value: 1)
Like.create(user_id: 4, media_id: 1, value: 0)
Like.create(user_id: 5, media_id: 1, value: 0)
Like.create(user_id: 6, media_id: 1, value: -1)
Like.create(user_id: 7, media_id: 1, value: -1)
Like.create(user_id: 1, media_id: , value: )
Like.create(user_id: 2, media_id: , value: )
Like.create(user_id: 3, media_id: , value: )
Like.create(user_id: 4, media_id: , value: )
Like.create(user_id: 5, media_id: , value: )
Like.create(user_id: 6, media_id: , value: )
Like.create(user_id: 7, media_id: , value: )
Like.create(user_id: , media_id: , value: )
Like.create(user_id: , media_id: , value: )
Like.create(user_id: , media_id: , value: )
Like.create(user_id: , media_id: , value: )
Like.create(user_id: , media_id: , value: )
Like.create(user_id: , media_id: , value: )
Like.create(user_id: , media_id: , value: )
Like.create(user_id: , media_id: , value: )

Recommendation.create(sender_id: , receiver_id: , media_id: "")