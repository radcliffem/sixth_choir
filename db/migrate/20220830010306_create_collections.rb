class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
    	t.string :name
    end

    create_join_table :collections, :pieces do |t|
    	t.index [:collection_id, :piece_id]
    	t.index [:piece_id, :collection_id]
    end
  end
end
