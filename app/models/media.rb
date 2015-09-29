class Media < ActiveRecord::Base
	has_many :recommendations
	has_many :likes
end
