class AddReferencePiecesComposers < ActiveRecord::Migration
  def change
  	add_reference :pieces, :composer, index: true
  end
end
