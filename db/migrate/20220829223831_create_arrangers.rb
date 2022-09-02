class CreateArrangers < ActiveRecord::Migration
  def change
    create_table :arrangers do |t|
    	t.string :first_name
    	t.string :middle_name
    	t.string :last_name
    	t.string :display_name
    end

    create_join_table :arrangers, :pieces do |t|
    	t.index [:arranger_id, :piece_id]
    	t.index [:piece_id, :arranger_id]
    end
  end
end
