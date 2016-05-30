require 'rails_helper'

RSpec.describe Movie, :type => :model do

  it "Associations with Media are intact" do
    medium = Medium.create!(media_type_id: 1)
    movie = Movie.create!(title: "Breaking Bad", medium_id: medium.id)
    medium.update(related_id: movie.id)

    expect(movie.medium).to eq(medium)
  end

end