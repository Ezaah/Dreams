class AddActiveToIdeals < ActiveRecord::Migration[5.1]
  def change
    add_column :ideals, :active, :boolean
  end
end
