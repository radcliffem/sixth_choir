class Season < ActiveRecord::Base
	has_many :performances

	def to_s
		liturgical_season
	end
end