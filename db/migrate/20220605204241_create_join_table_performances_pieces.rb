class CreateJoinTablePerformancesPieces < ActiveRecord::Migration
  def change
    create_join_table :performances, :pieces do |t|
      t.index :performance_id
      t.index :piece_id
    end
  end
end
