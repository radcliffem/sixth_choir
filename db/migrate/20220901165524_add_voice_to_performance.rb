class AddVoiceToPerformance < ActiveRecord::Migration
  def change
  	add_column :performances, :voice, :string
  end
end
