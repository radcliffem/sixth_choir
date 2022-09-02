class CreateJoinTables < ActiveRecord::Migration
  def change
  	create_join_table :seasons, :performances do |t|
    	t.index [:season_id, :performance_id]
    	t.index [:performance_id, :season_id]
  	end
  end
end
