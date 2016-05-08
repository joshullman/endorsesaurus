class MediaGenre < ActiveRecord::Base
	belongs_to :medium
	belongs_to :genre
end
