class Piece < ActiveRecord::Base
	belongs_to :composer
	has_and_belongs_to_many :arrangers
	has_many :performances
	belongs_to :collection
	accepts_nested_attributes_for :composer, :allow_destroy => true
	accepts_nested_attributes_for :performances, :allow_destroy => true
	accepts_nested_attributes_for :collection, :allow_destroy => true


  @@voice_options = ['2 part','2 part women','2 part men','3 part','4 part','bass solo','brass transcription','double choir','duet','mixed','SA','SAB','SATB','SB','solo','soprano solo','SS','SSA','SSAATTBB','SSATB','SSATBB','TB','TBB','treble','TTBB','unison','various','alto solo','tenor solo','SSAA','SAA']

	def seasons
		performances.map(&:seasons).uniq.map(&:liturgical_season)
	end

	def most_recent_performance
		performances.any? ? performances.map(&:date).max : nil
	end

	def display_composers
		composer.map(&:name).join(' | ')
	end

	def self.valid_voices
		@@voice_options.sort
	end

end
