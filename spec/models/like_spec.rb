require "rails_helper"

RSpec.describe Like, :type => :model do

	it "Associations with Media are intact" do
	  medium = Medium.create!(media_type_id: 1)
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

	  expect(like.medium).to eq(medium)
	end

	it "Associations with User are intact" do
	  medium = Medium.create!(media_type_id: 1)
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

	  expect(like.user).to eq(user_one)
	end

  it "find_associated_media method is intact for movies" do
    medium = Medium.create!(media_type_id: 1)
    movie = Movie.create!(title: "Gang Busters", medium_id: medium.id)
    medium.update(related_id: movie.id)
    user_one = User.create!(email: "blah@aol.com", password: "password")
    like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

    expect(like.find_associated_media).to eq(movie)
  end

  it "find_associated_media method is intact for shows" do
    medium = Medium.create!(media_type_id: 2)
    show = Show.create!(title: "Breaking Bad", medium_id: medium.id)
    medium.update(related_id: show.id)
    user_one = User.create!(email: "blah@aol.com", password: "password")
    like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

    expect(like.find_associated_media).to eq(show)
  end

  it "find_associated_media method is intact for seasons" do
    medium = Medium.create!(media_type_id: 3)
    season = Season.create!(season_num: 1, medium_id: medium.id)
    medium.update(related_id: season.id)
    user_one = User.create!(email: "blah@aol.com", password: "password")
    like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

    expect(like.find_associated_media).to eq(season)
  end

end