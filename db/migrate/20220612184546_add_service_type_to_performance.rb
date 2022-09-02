class AddServiceTypeToPerformance < ActiveRecord::Migration
  def change
  	add_column :performances, :service_type, :string
  end
end
