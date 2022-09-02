class CreateComposers < ActiveRecord::Migration
  def change
    create_table :composers do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :display_name
      t.string :nationality

      t.timestamps
    end
  end
end
