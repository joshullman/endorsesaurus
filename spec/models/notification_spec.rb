require 'rails_helper'

RSpec.describe Notification, :type => :model do

	it "belongs to sender" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  user_two = User.create!(email: "blah2@aol.com", password: "password")
	  note = Notification.create!(user_one_id: user_one.id, user_two_id: user_two.id)

	  expect(note.user_one).to eq(user_one)
	end

	it "belongs to receiver" do
	  medium = Medium.create!(media_type: "Movie")
	  user_one = User.create!(email: "blah@aol.com", password: "password")
	  user_two = User.create!(email: "blah2@aol.com", password: "password")
	  note = Notification.create!(user_one_id: user_one.id, user_two_id: user_two.id)

	  expect(note.user_two).to eq(user_two)
	end

end