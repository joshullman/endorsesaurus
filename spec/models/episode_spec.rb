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

end
