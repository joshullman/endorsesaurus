class Show < ActiveRecord::Base
	belongs_to :medium
	has_many   :seasons
end