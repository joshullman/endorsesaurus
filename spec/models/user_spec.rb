require "rails_helper"

RSpec.describe User, :type => :model do

	it "Associations with Likes are intact" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

	  expect(user_one.likes.first).to eq(like)
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

end