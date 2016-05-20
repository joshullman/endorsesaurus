class Season < ActiveRecord::Base
	belongs_to :show
	belongs_to :medium
	has_many   :episodes
end
