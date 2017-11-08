class CreateIdeals < ActiveRecord::Migration[5.1]
  def change
    create_table :ideals do |t|
      t.references :user, foreign_key: true
      t.string :type
      t.string :sensor
      t.integer :range_min
      t.integer :range_max
      t.timestamps
    end
  end
end
