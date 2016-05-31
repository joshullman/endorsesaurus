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
    movie = medium.create_movie!(title: "Gang Busters")
    
    expect(medium.find_associated_media).to eq(movie)
  end

  it "find_associated_media method is intact for shows" do
    medium = Medium.create!(media_type: "Show")
    show = medium.create_show!(title: "Breaking Bad")
    
    expect(medium.find_associated_media).to eq(show)
  end

  it "find_associated_media method is intact for seasons" do
    medium = Medium.create!(media_type: "Season")
    season = medium.create_season!(season_num: 1)

    expect(medium.find_associated_media).to eq(season)
  end

  it "find_associated_media method is intact for episodes" do
    medium = Medium.create!(media_type: "Episode")
    episode = medium.create_episode!(medium_id: medium.id)

    expect(medium.find_associated_media).to eq(medium.find_associated_media)
  end

  it "recommended_by method is intact" do
    medium = Medium.create!(media_type: "Season")
    season = Season.create!(season_num: 1)
    user_one = User.create!(email: "blah@aol.com", password: "password")
    user_two = User.create!(email: "blah2@aol.com", password: "password")
    rec = Recommendation.create!(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

    expect(medium.recommended_by(user_two.id).first).to eq(user_one)
  end

  it "recommended_by method is intact" do
    medium = Medium.create!(media_type: "Season")
    season = Season.create!(season_num: 1, medium_id: medium.id)
    user_one = User.create!(email: "blah@aol.com", password: "password")
    user_two = User.create!(email: "blah2@aol.com", password: "password")
    rec = Recommendation.create!(sender_id: user_one.id, receiver_id: user_two.id, medium_id: medium.id)

    expect(medium.recommended_to(user_one.id).first).to eq(user_two)
  end

  it "increment_likes method is intact for likes" do
    medium = Medium.create!(media_type: "Season")
    medium.increment_likes(1)

    expect(medium.liked_count).to eq(1)
  end

  it "decrement_likes method is intact for likes" do
    medium = Medium.create!(media_type: "Season")
    medium.increment_likes(1)
    medium.decrement_likes(1)

    expect(medium.liked_count).to eq(0)
  end

  it "increment_likes method is intact for seens" do
    medium = Medium.create!(media_type: "Season")
    medium.increment_likes(0)

    expect(medium.seen_count).to eq(1)
  end

  it "decrement_likes method is intact for seens" do
    medium = Medium.create!(media_type: "Season")
    medium.increment_likes(0)
    medium.decrement_likes(0)

    expect(medium.seen_count).to eq(0)
  end

  it "increment_likes method is intact for dislikes" do
    medium = Medium.create!(media_type: "Season")
    medium.increment_likes(-1)

    expect(medium.disliked_count).to eq(1)
  end

  it "decrement_likes method is intact for dislikes" do
    medium = Medium.create!(media_type: "Season")
    medium.increment_likes(-1)
    medium.decrement_likes(-1)

    expect(medium.disliked_count).to eq(0)
  end

  it "increment_watches method is intact" do
    medium = Medium.create!(media_type: "Season")
    medium.increment_watches

    expect(medium.watched_count).to eq(1)
  end

  it "increment_recommends method is intact" do
    medium = Medium.create!(media_type: "Season")
    medium.increment_recommends

    expect(medium.recommended_count).to eq(1)
  end

  it "decrement_recommends is intact" do
    medium = Medium.create!(media_type: "Season")
    medium.increment_recommends
    medium.decrement_recommends

    expect(medium.recommended_count).to eq(0)
  end

end