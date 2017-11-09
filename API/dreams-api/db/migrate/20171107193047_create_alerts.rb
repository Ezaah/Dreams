class CreateAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :alerts do |t|
      t.references :user, foreign_key: true
      t.string :sensor
      t.string :type

      t.timestamps
    end
  end
end
