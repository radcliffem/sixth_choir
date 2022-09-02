class Soloist < ActiveRecord::Base
	has_many :appearances
	
	accepts_nested_attributes_for :appearances, :allow_destroy => true


end
