class Movie < ActiveRecord::Base
	belongs_to :medium

	searchable do
		text :title
	end
end
