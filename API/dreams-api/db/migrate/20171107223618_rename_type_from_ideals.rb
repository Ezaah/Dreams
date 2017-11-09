class RenameTypeFromIdeals < ActiveRecord::Migration[5.1]
  def change
    rename_column :ideals, :type, :alert_type
  end
end
