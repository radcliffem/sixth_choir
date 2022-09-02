class AddPublisherToPieces < ActiveRecord::Migration
  def change
  	add_column :pieces, :publisher, :string
  	add_column :pieces, :catalog_number, :string
  	add_column :pieces, :acapella, :boolean
  	add_column :performances, :acapella, :boolean
  	add_column :pieces, :voices, :string, array: true, default: []
  	add_column :pieces, :special_parts, :string, array: true, default: []
  	add_column :pieces, :notes, :text
  end
end
