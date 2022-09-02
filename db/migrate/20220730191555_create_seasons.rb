class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
    	t.string :liturgical_season
    end

    create_join_table :seasons, :pieces do |t|
    	t.index [:season_id, :piece_id]
    	t.index [:piece_id, :season_id]
  	end
  end
end
