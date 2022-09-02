class Collection < ActiveRecord::Base
	has_many :pieces
	has_many :performances, through: :pieces

	accepts_nested_attributes_for :pieces, :allow_destroy => true

end