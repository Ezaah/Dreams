class RenameTypeFromAlerts < ActiveRecord::Migration[5.1]
  def change
    rename_column :alerts, :type, :alert_type
  end
end
