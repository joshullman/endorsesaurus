class Recommendation < ActiveRecord::Base
	belongs_to :sender
	belongs_to :receiver
	belongs_to :medium

end
