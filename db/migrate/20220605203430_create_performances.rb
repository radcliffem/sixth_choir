class CreatePerformances < ActiveRecord::Migration
  def change
    create_table :performances do |t|
      t.date :date
      t.string :purpose
      t.integer :piece_id

      t.timestamps
    end
  end
end
