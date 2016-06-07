require 'rails_helper'

RSpec.describe Show, :type => :model do

  it "Associations with Media are intact" do
      medium = Medium.create!(media_type: "Show")
      show = medium.create_show!(title: "Breaking Bad", medium_id: medium.id)

      expect(show.medium).to eq(medium)
    end

  it "Associations with Season are intact" do
  	show = Show.create!(title: "Breaking Bad")
  	season = Season.create!(show_id: show.id, season_num: 1)

  	expect(show.seasons.first).to eq(season)
  end

  it "watch_all method is intact" do
    show_med = Medium.create(media_type: "Show")
    show = show_med.create_show!(title: "Breaking Bad")
    season_med = Medium.create!(media_type: "Season")
    season = season_med.create_season!(show_id: show.id, season_num: 1)
    episode_med = Medium.create!(media_type: "Episode")
    episode = episode_med.create_episode!(season_id: season.id)
    user = User.create!(email: "Blah@aol.com", password: "password")
    show.watch_all(user, 1)

    expect(user.likes[0].find_associated_media).to eq(show)
    expect(user.likes[0].medium.watched_count).to eq(1)
    expect(user.likes[0].medium.liked_count).to eq(1)
    expect(user.likes[0].medium.seen_count).to eq(0)
    expect(user.likes[0].medium.disliked_count).to eq(0)
    expect(user.likes[1].find_associated_media).to eq(season)
    expect(user.likes[1].medium.watched_count).to eq(1)
    expect(user.likes[1].medium.liked_count).to eq(1)
    expect(user.likes[1].medium.seen_count).to eq(0)
    expect(user.likes[1].medium.disliked_count).to eq(0)
    expect(user.likes[2].find_associated_media).to eq(episode)
    expect(user.likes[2].medium.watched_count).to eq(1)
    expect(user.likes[2].medium.liked_count).to eq(1)
    expect(user.likes[2].medium.seen_count).to eq(0)
    expect(user.likes[2].medium.disliked_count).to eq(0)
  end

  it "update_likes method is intact" do
    show_med = Medium.create(media_type: "Show")
    show = show_med.create_show!(title: "Breaking Bad")
    season_med = Medium.create!(media_type: "Season")
    season = season_med.create_season!(show_id: show.id, season_num: 1)
    episode_med = Medium.create!(media_type: "Episode")
    episode = episode_med.create_episode!(season_id: season.id)
    user = User.create!(email: "Blah@aol.com", password: "password")
    like1 = Like.create!(user_id: user.id, medium_id: show_med.id, value: 1)
    show_med.increment_watches
    show_med.increment_likes(1)
    like2 = Like.create!(user_id: user.id, medium_id: season_med.id, value: 0)
    season_med.increment_watches
    season_med.increment_likes(0)
    like3 = Like.create!(user_id: user.id, medium_id: episode_med.id, value: -1)
    episode_med.increment_watches
    episode_med.increment_likes(-1)
    show.update_likes(user, 1)

    expect(user.likes[0].value).to eq(1)
    expect(user.likes[0].medium.watched_count).to eq(1)
    expect(user.likes[0].medium.liked_count).to eq(1)
    expect(user.likes[0].medium.seen_count).to eq(0)
    expect(user.likes[0].medium.disliked_count).to eq(0)
    expect(user.likes[1].value).to eq(1)
    expect(user.likes[1].medium.watched_count).to eq(1)
    expect(user.likes[1].medium.liked_count).to eq(1)
    expect(user.likes[1].medium.seen_count).to eq(0)
    expect(user.likes[1].medium.disliked_count).to eq(0)
    expect(user.likes[2].value).to eq(1)
    expect(user.likes[2].medium.watched_count).to eq(1)
    expect(user.likes[2].medium.liked_count).to eq(1)
    expect(user.likes[2].medium.seen_count).to eq(0)
    expect(user.likes[2].medium.disliked_count).to eq(0)
  end

  it "percents method is intact" do
    medium = Medium.create!(media_type: "Series")
    show = medium.create_show!(title: "Breaking Bad")
    user = User.create!(email: "Blah@aol.com", password: "password")
    like = Like.create!(user_id: user.id, medium_id: medium.id, value: 1)
    medium.increment_watches
    medium.increment_likes(1)

    expect(show.percents).to eq([100, 0, 0])
  end

end