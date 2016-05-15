require "rails_helper"

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