require "rails_helper"

RSpec.describe Recommendation, :type => :model do

  it "find_associated_media method is intact for movies" do
    medium = Medium.create!(media_type: "Movie")
    movie = medium.create_movie!(title: "Gang Busters")
    user_one = User.create!(email: "blah@aol.com", password: "password")
    user_two = User.create!(email: "blah2@aol.com", password: "password")
    rec = Recommendation.create(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

    expect(rec.find_associated_media).to eq(movie)
  end

  it "find_associated_media method is intact for shows" do
    medium = Medium.create!(media_type: "Show")
    show = medium.create_show!(title: "Breaking Bad")
    user_one = User.create!(email: "blah@aol.com", password: "password")
    user_two = User.create!(email: "blah2@aol.com", password: "password")
    rec = Recommendation.create(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

    expect(rec.find_associated_media).to eq(show)
  end

  it "find_associated_media method is intact for seasons" do
    medium = Medium.create!(media_type: "Season")
    season = medium.create_season!(season_num: 1)
    user_one = User.create!(email: "blah@aol.com", password: "password")
    user_two = User.create!(email: "blah2@aol.com", password: "password")
    rec = Recommendation.create(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

    expect(rec.find_associated_media).to eq(season)
  end

	it "Associations with Media are intact" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  user_two = User.create!(email: "blah2@aol.com", password: "password")
	  rec = Recommendation.create(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

	  expect(rec.medium).to eq(medium)
	end

	it "sender is intact" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  user_two = User.create!(email: "blah2@aol.com", password: "password")
	  rec = Recommendation.create(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

	  expect(rec.sender).to eq(user_one)
	end

	it "reciever is intact" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  user_two = User.create!(email: "blah2@aol.com", password: "password")
	  rec = Recommendation.create(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

	  expect(rec.receiver).to eq(user_two)
	end

end