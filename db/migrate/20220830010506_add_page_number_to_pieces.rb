class AddPageNumberToPieces < ActiveRecord::Migration
  def change
  	add_column :pieces, :page_number, :integer
  end
end
