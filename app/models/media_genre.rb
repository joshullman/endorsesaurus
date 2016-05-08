class MediaGenre < ActiveRecord::Base
	belongs_to :medium
	belongs_to :genre
	belongs_to :show
end
