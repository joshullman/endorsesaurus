require 'rails_helper'

RSpec.describe Movie, :type => :model do

  it "Associations with Media are intact" do
    medium = Medium.create!(media_type: "Movie")
    movie = medium.create_movie!(title: "Gang Busters")

    expect(movie.medium).to eq(medium)
  end

  it "percents method is intact" do
  	medium = Medium.create!(media_type: "Movie")
  	movie = medium.create_movie!(title: "Gang Busters")
  	user = User.create!(email: "Blah@aol.com", password: "password")
  	like = Like.create!(user_id: user.id, medium_id: medium.id, value: 1)
  	medium.increment_watches
  	medium.increment_likes(1)

  	expect(movie.percents).to eq([100, 0, 0])
  end

end