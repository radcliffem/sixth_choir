class RemoveColumnsFromPieces < ActiveRecord::Migration
  def change
  	remove_column :pieces, :lyricist, :string
  	remove_column :pieces, :instrumentation, :string
  	remove_column :pieces, :voicing
  end
end
