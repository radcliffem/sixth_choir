class Appearance < ActiveRecord::Base
	belongs_to :soloist
	has_and_belongs_to_many :performances

	delegate :instrument, to: :soloist
	delegate :name, to: :soloist

	accepts_nested_attributes_for :soloist, :allow_destroy => true
	accepts_nested_attributes_for :performances, :allow_destroy => true

	validate :compatible_performances

	def compatible_performances
		if performances.count > 0
			errors.add(:performances, "Error: Cannot have performances with multiple dates") if performances.map(&:date).uniq.count>1
			errors.add(:performances, "Error: Cannot have performance & appearance with different dates") if performances.map(&:date).uniq != date
		end
	end

	def display_appearance
		name + ' | ' + instrument
	end

	def display_appearance_date
		date.to_s + ' | ' + name
	end

	def date
		performances.any? ? performances.first.date : nil
	end

end
