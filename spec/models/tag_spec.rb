require 'rails_helper'

RSpec.describe Tag, :type => :model do

  it "Associations with Media are intact" do
    tag = Tag.create!(name: "horror")
    medium = Medium.create!(media_type: "Movie", related_id: 1)
    med_tag = MediaTag.create!(medium_id: medium.id, tag_id: tag.id)

    expect(tag.media.first).to eq(medium)
  end

  it "movies method is intact" do
    tag = Tag.create!(name: "horror")
    medium = Medium.create!(media_type: "Movie", related_id: 1)
    med_tag = MediaTag.create!(medium_id: medium.id, tag_id: tag.id)
    movie = Movie.create!(title: "Gang Busters", medium_id: medium.id)
    medium.update(related_id: movie.id)

    expect(tag.movies.first).to eq(medium.find_associated_media)
  end

  it "shows method is intact" do
    tag = Tag.create!(name: "horror")
    medium = Medium.create!(media_type: "Show", related_id: 1)
    med_tag = MediaTag.create!(medium_id: medium.id, tag_id: tag.id)
    show = Show.create!(title: "Breaking Bad", medium_id: medium.id)
    medium.update(related_id: show.id)

    expect(tag.shows.first).to eq(medium.find_associated_media)
  end

end