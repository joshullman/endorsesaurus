require "rails_helper"

# RSpec.describe User, :type => :model do
#   it "orders by last name" do
#     lindeman = User.create!(first_name: "Andy", last_name: "Lindeman")
#     chelimsky = User.create!(first_name: "David", last_name: "Chelimsky")

#     expect(User.ordered_by_last_name).to eq([chelimsky, lindeman])
#   end
# end

# RSpec.describe Like, :type => :model do
#   it "orders by last name" do
#     lindeman = Like.create!(first_name: "Andy", last_name: "Lindeman")
#     chelimsky = Like.create!(first_name: "David", last_name: "Chelimsky")

#     expect(Like.ordered_by_last_name).to eq([chelimsky, lindeman])
#   end
# end

# RSpec.describe Recommendation, :type => :model do
#   it "orders by last name" do
#     lindeman = Recommendation.create!(first_name: "Andy", last_name: "Lindeman")
#     chelimsky = Recommendation.create!(first_name: "David", last_name: "Chelimsky")

#     expect(Recommendation.ordered_by_last_name).to eq([chelimsky, lindeman])
#   end
# end

# RSpec.describe Media, :type => :model do
#   it "orders by last name" do
#     lindeman = Media.create!(first_name: "Andy", last_name: "Lindeman")
#     chelimsky = Media.create!(first_name: "David", last_name: "Chelimsky")

#     expect(Media.ordered_by_last_name).to eq([chelimsky, lindeman])
#   end
# end

# RSpec.describe Movie, :type => :model do
#   it "orders by last name" do
#     lindeman = Movie.create!(first_name: "Andy", last_name: "Lindeman")
#     chelimsky = Movie.create!(first_name: "David", last_name: "Chelimsky")

#     expect(Movie.ordered_by_last_name).to eq([chelimsky, lindeman])
#   end
# end

# RSpec.describe Show, :type => :model do
#   it "orders by last name" do
#     lindeman = Show.create!(first_name: "Andy", last_name: "Lindeman")
#     chelimsky = Show.create!(first_name: "David", last_name: "Chelimsky")

#     expect(Show.ordered_by_last_name).to eq([chelimsky, lindeman])
#   end
# end

# RSpec.describe Season, :type => :model do
#   it "orders by last name" do
#     lindeman = Season.create!(first_name: "Andy", last_name: "Lindeman")
#     chelimsky = Season.create!(first_name: "David", last_name: "Chelimsky")

#     expect(Season.ordered_by_last_name).to eq([chelimsky, lindeman])
#   end
# end

RSpec.describe Tag, :type => :model do
  it "it associates with Media" do
    tag = Tag.create!(name: "horror")
    med = Medium.create!(media_type: "Movie", related_id: 1)
    med_tag = MediaTag.create!(medium_id: med.id, tag_id: tag.id)

    expect(tag.media.first).to eq(med)
  end
end