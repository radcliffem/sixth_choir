class CreatePieces < ActiveRecord::Migration
  def change
    create_table :pieces do |t|
      t.string :title
      t.integer :year
      t.string :genre
      t.string :lyricist
      t.string :text
      t.string :voicing
      t.string :instrumentation

      t.timestamps
    end

  end
end
