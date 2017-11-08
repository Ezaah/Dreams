class AddActiveToAlerts < ActiveRecord::Migration[5.1]
  def change
    add_column :alerts, :active, :boolean
  end
end
