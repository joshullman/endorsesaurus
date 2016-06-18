require 'rails_helper'

RSpec.describe Season, :type => :model do

  it "Associations with Media are intact" do
    medium = Medium.create!(media_type: "Season")
    season = medium.create_season!(show_id: 1, season_num: 1)

    expect(season.medium).to eq(medium)
  end

  it "Associations with Show are intact" do
  	show = Show.create!(title: "Breaking Bad")
  	season = Season.create!(show_id: show.id, season_num: 1)

  	expect(season.show).to eq(show)
  end

  it "Associations with Episode are intact" do
    season = Season.create!(title: "Breaking Bad")
    episode = Episode.create!(season_id: season.id)

    expect(season.episodes.first).to eq(episode)
  end

  it "watch method is intact" do
    show_med = Medium.create!(media_type: "Show")
    show = show_med.create_show!(title: "Breaking Bad")
    season_med = Medium.create!(media_type: "Season")
    season = season_med.create_season!(show_id: show.id, season_num: 1)
    episode_med = Medium.create!(media_type: "Episode")
    episode = episode_med.create_episode!(season_id: season.id, show_id: show.id)
    episode_med2 = Medium.create!(media_type: "Episode")
    episode2 = episode_med2.create_episode!(season_id: season.id, show_id: show.id)
    user = User.create!(email: "Blah@aol.com", password: "password")
    like = Like.create!(user_id: user.id, medium_id: episode_med.id, value: -1)
    episode_med.increment_watches
    episode_med.increment_likes(-1)
    like2 = Like.create!(user_id: user.id, medium_id: episode_med2.id, value: 0)
    episode_med2.increment_watches
    episode_med2.increment_likes(0)
    season.watch(user, 1)

    expect(user.likes.first.find_associated_media).to eq(episode)
    expect(user.likes.first.medium.watched_count).to eq(1)
    expect(user.likes.first.medium.liked_count).to eq(1)
    expect(user.likes.first.medium.seen_count).to eq(0)
    expect(user.likes.first.medium.disliked_count).to eq(0)
    expect(user.likes.last.find_associated_media).to eq(episode2)
    expect(user.likes.last.medium.watched_count).to eq(1)
    expect(user.likes.last.medium.liked_count).to eq(1)
    expect(user.likes.last.medium.seen_count).to eq(0)
    expect(user.likes.last.medium.disliked_count).to eq(0)
  end

  it "recommend_to method is intact" do
  end

  it "unrecommend_to method is intact" do
  end

  it "percents method is intact" do
    medium = Medium.create!(media_type: "Series")
    season = medium.create_season!(title: "Breaking Bad")
    user = User.create!(email: "Blah@aol.com", password: "password")
    like = Like.create!(user_id: user.id, medium_id: medium.id, value: 1)
    medium.increment_watches
    medium.increment_likes(1)

    expect(season.percents).to eq([100, 0, 0])
  end

end