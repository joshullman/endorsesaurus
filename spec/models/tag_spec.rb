require 'rails_helper'

RSpec.describe Tag, :type => :model do

  it "Associations with Media are intact" do
    tag = Tag.create!(name: "horror")
    medium = Medium.create!(media_type: "Movie")
    med_tag = MediaTag.create!(medium_id: medium.id, tag_id: tag.id)

    expect(tag.media.first).to eq(medium)
  end

  it "movies method is intact" do
    tag = Tag.create!(name: "horror")
    medium = Medium.create!(media_type: "Movie")
    med_tag = MediaTag.create!(medium_id: medium.id, tag_id: tag.id)
    movie = medium.create_movie!(title: "Gang Busters")

    expect(tag.movies.first).to eq(medium.find_associated_media)
  end

  it "shows method is intact" do
    tag = Tag.create!(name: "horror")
    medium = Medium.create!(media_type: "Show")
    med_tag = MediaTag.create!(medium_id: medium.id, tag_id: tag.id)
    show = medium.create_show!(title: "Breaking Bad")

    expect(tag.shows.first).to eq(medium.find_associated_media)
  end

end