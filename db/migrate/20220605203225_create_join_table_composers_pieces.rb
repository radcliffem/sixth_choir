class CreateJoinTableComposersPieces < ActiveRecord::Migration
  def change
    create_join_table :composers, :pieces do |t|
      t.index [:composer_id, :piece_id]
      t.index [:piece_id, :composer_id]
    end
  end
end
