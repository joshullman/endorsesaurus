require "rails_helper"

RSpec.describe Like, :type => :model do

	it "Associations with Media are intact" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

	  expect(like.medium).to eq(medium)
	end

	it "Associations with User are intact" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

	  expect(like.user).to eq(user_one)
	end

  it "find_associated_media method is intact for movies" do
    medium = Medium.create!(media_type: "Movie")
    movie = medium.create_movie!(title: "Gang Busters")
    user_one = User.create!(email: "blah@aol.com", password: "password")
    like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

    expect(like.find_associated_media).to eq(movie)
  end

  it "find_associated_media method is intact for shows" do
    medium = Medium.create!(media_type: "Show")
    show = medium.create_show!(title: "Breaking Bad")
    user_one = User.create!(email: "blah@aol.com", password: "password")
    like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

    expect(like.find_associated_media).to eq(show)
  end

  it "find_associated_media method is intact for seasons" do
    medium = Medium.create!(media_type: "Season")
    season = medium.create_season!(season_num: 1)
    user_one = User.create!(email: "blah@aol.com", password: "password")
    like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

    expect(like.find_associated_media).to eq(season)
  end

end