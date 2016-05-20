class Episode < ActiveRecord::Base
	belongs_to :medium
	belongs_to :season
end
