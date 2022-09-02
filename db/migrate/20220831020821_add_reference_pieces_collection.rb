class AddReferencePiecesCollection < ActiveRecord::Migration
  def change
  	add_reference :pieces, :collection, index: true
  end
end
