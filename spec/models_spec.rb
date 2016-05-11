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

end

RSpec.describe Medium, :type => :model do

  it "Associations with Likes are intact" do
    medium = Medium.create!(media_type: "Movie")
    user_one = User.create!(email: "blah@aol.com", password: "password")
    like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

    expect(medium.likes.first).to eq(like)
  end

  it "Associations with Recommendations are intact" do
   medium = Medium.create!(media_type: "Movie")
   user_one = User.create!(email: "blah@aol.com", password: "password")
   user_two = User.create!(email: "blah2@aol.com", password: "password")
   rec = Recommendation.create(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

   expect(medium.recommendations.first).to eq(rec)
 end

  it "Associations with Tags are intact" do
    medium = Medium.create!(media_type: "Movie")
    tag = Tag.create!(name: "Horror")
    med_tag = MediaTag.create(medium_id: medium.id, tag_id: tag.id)

    expect(medium.tags.first).to eq(tag)
  end

  it "find_associated_media method is intact for movies" do
    medium = Medium.create!(media_type: "Movie")
    movie = Movie.create!(title: "Gang Busters", medium_id: medium.id)
    medium.update(related_id: movie.id)

    expect(medium.find_associated_media).to eq(movie)
  end

  it "find_associated_media method is intact for shows" do
    medium = Medium.create!(media_type: "Show")
    show = Show.create!(title: "Breaking Bad", medium_id: medium.id)
    medium.update(related_id: show.id)

    expect(medium.find_associated_media).to eq(show)
  end

  it "find_associated_media method is intact for seasons" do
    medium = Medium.create!(media_type: "Season")
    season = Season.create!(season_num: 1, medium_id: medium.id)
    medium.update(related_id: season.id)

    expect(medium.find_associated_media).to eq(season)
  end

end

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
    movie = Movie.create!(title: "Gang Busters", medium_id: medium.id)
    medium.update(related_id: movie.id)
    user_one = User.create!(email: "blah@aol.com", password: "password")
    like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

    expect(like.find_associated_media).to eq(movie)
  end

  it "find_associated_media method is intact for shows" do
    medium = Medium.create!(media_type: "Show")
    show = Show.create!(title: "Breaking Bad", medium_id: medium.id)
    medium.update(related_id: show.id)
    user_one = User.create!(email: "blah@aol.com", password: "password")
    like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

    expect(like.find_associated_media).to eq(show)
  end

  it "find_associated_media method is intact for seasons" do
    medium = Medium.create!(media_type: "Season")
    season = Season.create!(season_num: 1, medium_id: medium.id)
    medium.update(related_id: season.id)
    user_one = User.create!(email: "blah@aol.com", password: "password")
    like = Like.create!(user_id: user_one.id, medium_id: medium.id, value: 1)

    expect(like.find_associated_media).to eq(season)
  end

end

RSpec.describe Recommendation, :type => :model do

  it "find_associated_media method is intact for movies" do
    medium = Medium.create!(media_type: "Movie")
    movie = Movie.create!(title: "Gang Busters", medium_id: medium.id)
    medium.update(related_id: movie.id)
    user_one = User.create!(email: "blah@aol.com", password: "password")
    user_two = User.create!(email: "blah2@aol.com", password: "password")
    rec = Recommendation.create(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

    expect(rec.find_associated_media).to eq(movie)
  end

  it "find_associated_media method is intact for shows" do
    medium = Medium.create!(media_type: "Show")
    show = Show.create!(title: "Breaking Bad", medium_id: medium.id)
    medium.update(related_id: show.id)
    user_one = User.create!(email: "blah@aol.com", password: "password")
    user_two = User.create!(email: "blah2@aol.com", password: "password")
    rec = Recommendation.create(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

    expect(rec.find_associated_media).to eq(show)
  end

  it "find_associated_media method is intact for seasons" do
    medium = Medium.create!(media_type: "Season")
    season = Season.create!(season_num: 1, medium_id: medium.id)
    medium.update(related_id: season.id)
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


RSpec.describe Movie, :type => :model do

  it "Associations with Media are intact" do
    medium = Medium.create!(media_type: "Movie")
    movie = Movie.create!(title: "Breaking Bad", medium_id: medium.id)
    medium.update(related_id: movie.id)

    expect(movie.medium).to eq(medium)
  end

end

RSpec.describe Show, :type => :model do

  it "Associations with Media are intact" do
      medium = Medium.create!(media_type: "Show")
      show = Show.create!(title: "Breaking Bad", medium_id: medium.id)
      medium.update(related_id: show.id)

      expect(show.medium).to eq(medium)
    end

  it "Associations with Season are intact" do
  	show = Show.create!(title: "Breaking Bad")
  	season = Season.create!(show_id: show.id, season_num: 1, points: 1)

  	expect(show.seasons.first).to eq(season)
  end

end

RSpec.describe Season, :type => :model do

  it "Associations with Media are intact" do
    medium = Medium.create!(media_type: "Season")
    season = Season.create!(show_id: 1, season_num: 1, points: 1, medium_id: medium.id)
    medium.update(related_id: season.id)

    expect(season.medium).to eq(medium)
  end

  it "Associations with Show are intact" do
  	show = Show.create!(title: "Breaking Bad")
  	season = Season.create!(show_id: show.id, season_num: 1, points: 1)

  	expect(season.show).to eq(show)
  end
end

RSpec.describe Tag, :type => :model do

  it "Associations with Media are intact" do
    tag = Tag.create!(name: "horror")
    medium = Medium.create!(media_type: "Movie", related_id: 1)
    med_tag = MediaTag.create!(medium_id: medium.id, tag_id: tag.id)

    expect(tag.media.first).to eq(medium)
  end

  it "movies method is intact" do
    tag = Tag.create!(name: "horror")
    medium = Medium.create!(media_type: "Movie", related_id: 1)
    med_tag = MediaTag.create!(medium_id: medium.id, tag_id: tag.id)
    movie = Movie.create!(title: "Gang Busters", medium_id: medium.id)
    medium.update(related_id: movie.id)

    expect(tag.movies.first).to eq(medium.find_associated_media)
  end

  it "shows method is intact" do
    tag = Tag.create!(name: "horror")
    medium = Medium.create!(media_type: "Show", related_id: 1)
    med_tag = MediaTag.create!(medium_id: medium.id, tag_id: tag.id)
    show = Show.create!(title: "Breaking Bad", medium_id: medium.id)
    medium.update(related_id: show.id)

    expect(tag.shows.first).to eq(medium.find_associated_media)
  end

end