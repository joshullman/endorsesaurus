require 'rails_helper'

RSpec.describe Movie, :type => :model do

  it "Associations with Media are intact" do
    medium = Medium.create!(media_type: "Movie")
    movie = medium.create_movie!(title: "Breaking Bad")

    expect(movie.medium).to eq(medium)
  end

end