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

end