class CreateMeasurements < ActiveRecord::Migration[5.1]
  def change
    create_table :measurements do |t|
      t.belongs_to :user, index: true
      t.integer :light
      t.integer :sound
      t.integer :temperature
      t.integer :humidity
      t.boolean :active
      t.datetime :measured_at
      t.timestamps
    end
  end
end
