class CreateSoloists < ActiveRecord::Migration
  def change
    create_table :soloists do |t|
    	t.string :name
    	t.string :phone_number
    	t.string :email
    	t.string :instrument

    	t.timestamps
    end
  end
end
