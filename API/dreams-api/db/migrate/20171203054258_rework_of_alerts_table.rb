class ReworkOfAlertsTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :alerts, :sensor, :string
    remove_column :alerts, :alert_type, :string
    add_column :alerts, :measurement_id, :bigint
    add_column :alerts, :light_alert, :string
    add_column :alerts, :sound_alert, :string
    add_column :alerts, :temperature_alert, :string
    add_column :alerts, :humidity_alert, :string
    add_index :alerts, :measurement_id
  end
end
