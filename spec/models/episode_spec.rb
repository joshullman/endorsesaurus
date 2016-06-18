require 'rails_helper'

RSpec.describe Episode, type: :model do

  it "Associations with Medium are intact" do
    medium = Medium.create!(media_type: "Episode")
    episode = medium.create_episode!(title: "Blah")
    
    expect(episode.medium).to eq(medium)
  end

  it "Associations with Season are intact" do
    season = Season.create!(title: "Breaking Bad")
    episode = Episode.create!(season_id: season.id)

    expect(episode.season).to eq(season)
  end

  it "Associations with Show are intact" do
    show = Show.create!(title: "Breaking Bad")
    episode = Episode.create!(show_id: show.id)

    expect(episode.show).to eq(show)
  end

  it "update_like method is intact" do
    show_med = Medium.create!(media_type: "Show")
    show = show_med.create_show!(title: "Breaking Bad")
    season_med = Medium.create!(media_type: "Season")
    season = season_med.create_season!(show_id: show.id, season_num: 1)
    episode_med = Medium.create!(media_type: "Episode")
    episode = episode_med.create_episode!(season_id: season.id, show_id: show.id)
    user = User.create!(email: "Blah@aol.com", password: "password")
    like = Like.create!(user_id: user.id, medium_id: episode_med.id, value: -1)
    episode_med.increment_watches
    episode_med.increment_likes(-1)
    episode.watch(user, 1)

    expect(user.likes.first.find_associated_media).to eq(episode)
    expect(user.likes.first.medium.watched_count).to eq(1)
    expect(user.likes.first.medium.liked_count).to eq(1)
    expect(user.likes.first.medium.seen_count).to eq(0)
    expect(user.likes.first.medium.disliked_count).to eq(0)
  end

  it "like_and_distribute_points method is intact" do
    show_med = Medium.create!(media_type: "Show")
    show = show_med.create_show!(title: "Breaking Bad")
    season_med = Medium.create!(media_type: "Season")
    season = season_med.create_season!(show_id: show.id, season_num: 1)
    episode_med = Medium.create!(media_type: "Episode")
    episode = episode_med.create_episode!(season_id: season.id, show_id: show.id, points: 1)

    user_one = User.create!(email: "blah@aol.com", password: "password")
    user_two = User.create!(email: "blah2@aol.com", password: "password")
    rec = Recommendation.create!(sender_id: user_one.id, receiver_id: user_two.id, medium_id: episode_med.id)

    episode.like_and_distribute_points(user_two, 1)
    expect(user_two.likes.first.find_associated_media).to eq(episode)
    expect(user_two.likes.first.medium.watched_count).to eq(1)
    expect(user_two.likes.first.medium.liked_count).to eq(1)
    expect(user_two.likes.first.medium.seen_count).to eq(0)
    expect(user_two.likes.first.medium.disliked_count).to eq(0)
    expect(user_two.points).to eq(1)
    expect(user_one.points).to eq(1)

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
    episode.watch(user, 1)
    episode2.watch(user, 1)

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

end
