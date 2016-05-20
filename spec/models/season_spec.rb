require 'rails_helper'

RSpec.describe Season, :type => :model do

  it "Associations with Media are intact" do
    medium = Medium.create!(media_type: "Season")
    season = Season.create!(show_id: 1, season_num: 1, medium_id: medium.id)
    medium.update(related_id: season.id)

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

end