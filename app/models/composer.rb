class Composer < ActiveRecord::Base
	has_and_belongs_to_many :pieces
	accepts_nested_attributes_for :pieces, :allow_destroy => true

	has_many :performances, through: :pieces

	# scope by_name order(:name)

	def name
		if display_name.present?
			display_name
		else 
			all_names = [first_name, middle_name, last_name].compact
			all_names.join(' ')
		end
	end

	def self.find_or_create_composer(first_name:nil, middle_name:nil, last_name:nil, display_name:nil, nationality:nil)
		puts "looking for #{first_name}, #{middle_name}, #{last_name}"
		possible_composers = Composer.where(first_name: first_name, last_name: last_name)
		if possible_composers.any?
			puts possible_composers.map(&:name)
			puts "Is one of these your composer?"
			if STDIN.gets.chomp=='y'
				return nil
			end
		end
		return Composer.create!(first_name: first_name, middle_name: middle_name, last_name: last_name, display_name: display_name, nationality: nationality)
	end


end
