class AddReferencePerformancesSeasons < ActiveRecord::Migration
  def change
  	  add_reference :performances, :season, index: true
  end
end
