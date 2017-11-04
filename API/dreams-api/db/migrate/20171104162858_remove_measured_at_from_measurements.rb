class RemoveMeasuredAtFromMeasurements < ActiveRecord::Migration[5.1]
  def change
    remove_column :measurements, :measured_at, :datetime
  end
end
