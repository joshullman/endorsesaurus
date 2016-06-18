require "rails_helper"

RSpec.describe User, :type => :model do

	it "Associations with Likes are intact" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

	  expect(user_one.likes.first).to eq(like)
	end

	it "sent_notifications method is intact" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  note = Notification.create!(user_one_id: user_one.id)

	  expect(user_one.sent_notifications.first).to eq(note)
	end

	it "received_notifications method is intact" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  user_two = User.create!(email: "blah2@aol.com", password: "password")
	  note = Notification.create!(user_one_id: user_two.id, user_two_id: user_one.id)

	  expect(user_one.received_notifications.first).to eq(note)
	end

	it "notifications method is intact" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  note = Notification.create!(user_one_id: user_one.id)

	  expect(user_one.notifications.first).to eq(note)
	end

	it "has_recommended_to? method is intact" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  user_two = User.create!(email: "blah2@aol.com", password: "password")
	  rec = Recommendation.create!(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

	  expect(user_one.has_recommended_to?(user_two.id, medium.id)).to eq(true)
	end

	# it "recent_activity method is intact" do
	#   medium = Medium.create!(media_type: "Movie")
 #    movie = medium.create_movie!(title: "Breaking Bad")
	#   user_one = User.create!(email: "blah@aol.com", password: "password")
	#   note = Notification.create!(user_one_id: user_one.id, medium_id: medium.id)

	#   expect(user_one.recent_activity.first).to eq(note)
	# end
	
	it "update_points method is intact" do
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  user_one.update_points(1)

	  expect(user_one.points).to eq(1)
	end

	it "sent_recs is intact" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  user_two = User.create!(email: "blah2@aol.com", password: "password")
	  rec = Recommendation.create(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

	  expect(user_one.sent_recs.first).to eq(rec)
	end

	it "recieved_recs is intact" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  user_two = User.create!(email: "blah2@aol.com", password: "password")
	  rec = Recommendation.create(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

	  expect(user_two.received_recs.first).to eq(rec)
	end

	it "friendship belongs to user actively" do
	  user = User.create!(email: "blah@aol.com", password: "password")
	  friend = User.create!(email: "blah2@aol.com", password: "password")
	  friendship = Friendship.create!(user_id: user.id, friend_id: friend.id, accepted: true)

	  expect(user.friendships.first).to eq(friendship)
	end

	it "friendship belongs to friend passively" do
	  user = User.create!(email: "blah@aol.com", password: "password")
	  friend = User.create!(email: "blah2@aol.com", password: "password")
	  friendship = Friendship.create!(user_id: user.id, friend_id: friend.id, accepted: true)

	  expect(friend.passive_friendships.first).to eq(friendship)
	end

	it "active friends is intact" do
	  user = User.create!(email: "blah@aol.com", password: "password")
	  friend = User.create!(email: "blah2@aol.com", password: "password")
	  friendship = Friendship.create!(user_id: user.id, friend_id: friend.id, accepted: true)

	  expect(user.active_friends.first).to eq(friend)
	end

	it "passive friends is intact" do
	  user = User.create!(email: "blah@aol.com", password: "password")
	  friend = User.create!(email: "blah2@aol.com", password: "password")
	  friendship = Friendship.create!(user_id: user.id, friend_id: friend.id, accepted: true)

	  expect(friend.passive_friends.first).to eq(user)
	end

	it "pending friends is intact" do
	  user = User.create!(email: "blah@aol.com", password: "password")
	  friend = User.create!(email: "blah2@aol.com", password: "password")
	  friendship = Friendship.create!(user_id: user.id, friend_id: friend.id, accepted: false)

	  expect(user.pending_friends.first).to eq(friend)
	end

	it "requested friendships is intact" do
	  user = User.create!(email: "blah@aol.com", password: "password")
	  friend = User.create!(email: "blah2@aol.com", password: "password")
	  friendship = Friendship.create!(user_id: user.id, friend_id: friend.id, accepted: false)

	  expect(friend.requested_friendships.first).to eq(user)
	end

	it "friends method is intact" do
	  user = User.create!(email: "blah@aol.com", password: "password")
	  friend = User.create!(email: "blah2@aol.com", password: "password")
	  friendship = Friendship.create!(user_id: user.id, friend_id: friend.id, accepted: true)

	  expect(user.friends.first).to eq(friend)
	end

	it "user_likes method is intact" do
		user_one = User.create!(email: "blah@aol.com", password: "password")
		season_med = Medium.create!(media_type: "Season")
    season = season_med.create_season!(season_num: 1)
    like = Like.create!(user_id: user_one.id, medium_id: season_med.id, value: 1)

    expect(user_one.user_likes).to eq({season_med.id => 1})
	end

	# it "friends_recent_activity method is intact" do
	# end

	it "watched_all_episodes? method is intact" do
		user_one = User.create!(email: "blah@aol.com", password: "password")
		show_med = Medium.create(media_type: "Show")
    show = show_med.create_show!(title: "Breaking Bad")
		season_med = Medium.create!(media_type: "Season")
    season = season_med.create_season!(show_id: show.id, season_num: 1)
    episode_med = Medium.create!(media_type: "Episode")
    episode = episode_med.create_episode!(season_id: season.id)
    episode_med2 = Medium.create!(media_type: "Episode")
    episode2 = episode_med2.create_episode!(season_id: season.id)
    Like.create!(user_id: user_one.id, medium_id: episode_med.id, value: 1)
    Like.create!(user_id: user_one.id, medium_id: episode_med2.id, value: 1)
	  
	  expect(user_one.watched_all_episodes?(season.id)).to eq([true, 1])
	end

	it "watched_all_seasons? method is intact" do
		user_one = User.create!(email: "blah@aol.com", password: "password")
		show_med = Medium.create(media_type: "Show")
    show = show_med.create_show!(title: "Breaking Bad")
    season_med = Medium.create!(media_type: "Season")
    season = season_med.create_season!(show_id: show.id, season_num: 1)
    season_med2 = Medium.create!(media_type: "Season")
    season2 = season_med2.create_season!(show_id: show.id, season_num: 2)
    episode_med = Medium.create!(media_type: "Episode")
    episode = episode_med.create_episode!(season_id: season.id, show_id: show.id)
    episode_med2 = Medium.create!(media_type: "Episode")
    episode2 = episode_med2.create_episode!(season_id: season2.id, show_id: show.id)
    like = Like.create!(user_id: user_one.id, medium_id: episode_med.id, value: -1)
    like2 = Like.create!(user_id: user_one.id, medium_id: episode_med2.id, value: 0)
	  
	  expect(user_one.watched_all_seasons?(show.id)).to eq([true, nil])
	end

	it "already_recommended_show_to? method is intact" do
		user_one = User.create!(email: "blah@aol.com", password: "password")
	  user_two = User.create!(email: "blah2@aol.com", password: "password")
	  show_med = Medium.create(media_type: "Show")
    show = show_med.create_show!(title: "Breaking Bad")

    season_med = Medium.create!(media_type: "Season")
    season = season_med.create_season!(show_id: show.id, season_num: 1)
    episode_med = Medium.create!(media_type: "Episode")
    episode = episode_med.create_episode!(season_id: season.id)
    episode_med2 = Medium.create!(media_type: "Episode")
    episode2 = episode_med2.create_episode!(season_id: season.id)

    season_med2 = Medium.create!(media_type: "Season")
    season2 = season_med2.create_season!(show_id: show.id, season_num: 2)
    episode_med3 = Medium.create!(media_type: "Episode")
    episode = episode_med3.create_episode!(season_id: season2.id)
    episode_med4 = Medium.create!(media_type: "Episode")
    episode4 = episode_med4.create_episode!(season_id: season2.id)
	  
	  Recommendation.create!(sender_id: user_one.id, receiver_id: user_two.id, medium_id: season_med.id)
	  Recommendation.create!(sender_id: user_one.id, receiver_id: user_two.id, medium_id: season_med2.id)
	  expect(user_one.already_recommended_show_to?(user_two, show.id)).to eq(true)
	end

	it "season_progress method is intact" do
		show_med = Medium.create!(media_type: "Show")
    show = show_med.create_show!(title: "Breaking Bad")

    season_med = Medium.create!(media_type: "Season")
    season = season_med.create_season!(show_id: show.id, season_num: 1)
    episode_med = Medium.create!(media_type: "Episode")
    episode = episode_med.create_episode!(season_id: season.id, show_id: show.id)
    episode_med2 = Medium.create!(media_type: "Episode")
    episode2 = episode_med2.create_episode!(season_id: season.id, show_id: show.id)

    season.update(episode_count: 2)

    season_med2 = Medium.create!(media_type: "Season")
    season2 = season_med2.create_season!(show_id: show.id, season_num: 2)
    episode_med3 = Medium.create!(media_type: "Episode")
    episode = episode_med3.create_episode!(season_id: season2.id, show_id: show.id)
    episode_med4 = Medium.create!(media_type: "Episode")
    episode4 = episode_med4.create_episode!(season_id: season2.id, show_id: show.id)

    show.update(episode_count: 4)

    user = User.create!(email: "Blah@aol.com", password: "password")
    like1 = Like.create!(user_id: user.id, medium_id: episode_med.id, value: 1)
    episode_med.increment_watches
    episode_med.increment_likes(1)
    like2 = Like.create!(user_id: user.id, medium_id: episode_med2.id, value: 0)
    episode_med2.increment_watches
    episode_med2.increment_likes(0)
    like3 = Like.create!(user_id: user.id, medium_id: episode_med3.id, value: -1)
    episode_med3.increment_watches
    episode_med3.increment_likes(-1)

		expect(user.season_progress(season)).to eq([50, 50, 0, 0])
	end

	it "show_progress method is intact" do
		show_med = Medium.create!(media_type: "Show")
    show = show_med.create_show!(title: "Breaking Bad")

    season_med = Medium.create!(media_type: "Season")
    season = season_med.create_season!(show_id: show.id, season_num: 1)
    episode_med = Medium.create!(media_type: "Episode")
    episode = episode_med.create_episode!(season_id: season.id, show_id: show.id)
    episode_med2 = Medium.create!(media_type: "Episode")
    episode2 = episode_med2.create_episode!(season_id: season.id, show_id: show.id)

    season_med2 = Medium.create!(media_type: "Season")
    season2 = season_med2.create_season!(show_id: show.id, season_num: 2)
    episode_med3 = Medium.create!(media_type: "Episode")
    episode = episode_med3.create_episode!(season_id: season2.id, show_id: show.id)
    episode_med4 = Medium.create!(media_type: "Episode")
    episode4 = episode_med4.create_episode!(season_id: season2.id, show_id: show.id)

    show.update(episode_count: 4)

    user = User.create!(email: "Blah@aol.com", password: "password")
    like1 = Like.create!(user_id: user.id, medium_id: episode_med.id, value: 1)
    episode_med.increment_watches
    episode_med.increment_likes(1)
    like2 = Like.create!(user_id: user.id, medium_id: episode_med2.id, value: 0)
    episode_med2.increment_watches
    episode_med2.increment_likes(0)
    like3 = Like.create!(user_id: user.id, medium_id: episode_med3.id, value: -1)
    episode_med3.increment_watches
    episode_med3.increment_likes(-1)

		expect(user.show_progress(show)).to eq([25, 25, 25, 25])
	end

end