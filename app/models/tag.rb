class Tag < ActiveRecord::Base
	has_many :media_tags
	has_many :media, through: :media_tags
end
