class Arranger < ActiveRecord::Base
	has_and_belongs_to_many :pieces
	accepts_nested_attributes_for :pieces, :allow_destroy => true

	has_many :performances, through: :pieces

	# scope by_name order(:name)

	def name
		if display_name.present?
			display_name
		elsif middle_name.present?
			first_name + ' ' + middle_name + ' ' + last_name
		else
			first_name + ' ' + last_name
		end
	end

	def self.find_or_create_arranger(first_name:nil, middle_name:nil, last_name:nil, display_name:nil)
		puts "looking for #{first_name}, #{middle_name}, #{last_name}"
		possible_arrangers = Arranger.where(first_name: first_name, last_name: last_name)
		if possible_arrangers.any?
			puts possible_arrangers.map(&:name)
			puts "Is one of these your arranger?"
			if STDIN.gets.chomp=='y'
				return nil
			end
		end
		return Arranger.create!(first_name: first_name, middle_name: middle_name, last_name: last_name, display_name: display_name)
	end
end
