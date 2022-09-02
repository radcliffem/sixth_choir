class Performance < ActiveRecord::Base
	belongs_to :piece
	has_and_belongs_to_many :appearances
	has_many :composers, through: :piece
	accepts_nested_attributes_for :piece, :allow_destroy => true
	accepts_nested_attributes_for :appearances, :allow_destroy => true
	belongs_to :season

	validate :compatible_appearances
	validate :compatible_voicing

	delegate :title, to: :piece

	def compatible_appearances
		if appearances.present? && appearances.flat_map(&:performances).any?
			if (appearances.flat_map(&:performances).map(&:date).uniq.count > 1 || appearances.flat_map(&:performances).map(&:date).uniq.first != date)
				errors.add(:appearances, "Error: Cannot have appearance with different date than performance") 
			end
		end
	end

	def compatible_voicing
		errors.add(:voice, "Error: Voicing for performance not permissible for piece") if !piece.voices.include?(voice)&&voice.present?
	end


	def display_performance
		date.to_s + ' ' + purpose + ' | ' + title
	end

	def liturgical_season
		season.present? ? season.liturgical_season : ''
	end

end
