class CreateAppearances < ActiveRecord::Migration
  def change
    create_table :appearances do |t|
    	t.date :date
    	t.integer :payment

    	t.timestamps
    end

    create_join_table :appearances, :soloists do |t|
    	t.index [:appearance_id, :soloist_id]
    	t.index [:soloist_id, :appearance_id]
    end

    create_join_table :appearances, :performances do |t|
    	t.index :appearance_id
    	t.index :performance_id
    end

    add_reference :appearances, :soloist, index: true
  end
end
